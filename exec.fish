map jobs

function __asyncJob
  set -l func $argv[1]
  set -l outputVar $argv[2]
  set -l caller $argv[3]
  set -l behaviour "set -U $outputVar ($func); kill -WINCH $caller;"
  set -l functionBody (functions $func | grep -v '^#' | sed -E 's/$/;/' | sed -e "s/^end;/end; $behaviour/")
  fish -c "$functionBody" &
end

function execAsync
  set -l func $argv[1]
  set -l outputVar $argv[2]
  kill -9 (map jobs $func) >/dev/null 2>&1

  __asyncJob $func $outputVar %self

  map jobs $func (jobs -l -p)
end

function execSync
  set -l func $argv[1]
  set -l outputVar $argv[2]

  set $outputVar (eval $func)
end
