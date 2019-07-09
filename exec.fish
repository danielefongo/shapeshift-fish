map jobs
map outputs

function __asyncJob
  set -l func $argv[1]
  set -l caller $argv[2]
  set -l behaviour "map outputs $func ($func); kill -WINCH $caller;"
  set -l functionBody (functions $func | grep -v '^#' | sed -E 's/$/;/' | sed -e "s/^end;/end; $behaviour/")
  set mapfunc (functions map | grep -v '^#' | sed -E 's/$/;/')
  fish -c "$mapfunc; $functionBody" &
end

function execAsync
  set -l func $argv[1]
  set -l outputVar $argv[2]
  kill -9 (map jobs $func) >/dev/null 2>&1

  __asyncJob $func %self

  map jobs $func (jobs -l -p)
end

function execSync
  set -l func $argv[1]
  set -l outputVar $argv[2]

  map outputs $func (eval $func)
end
