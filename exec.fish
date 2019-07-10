map jobs
map outputs

function __asyncJob
  set -l func $argv[1]
  set -l caller $argv[2]

  set -l mapFunctionBody (__bodyOf map)
  set -l functionBody (__bodyOf $func)
  set -l behaviour "map outputs $func ($func); kill -WINCH $caller;"

  fish -c "$mapFunctionBody; $functionBody; $behaviour" &
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

function resultFor
  set -l func $argv[1]

  map outputs $func
end

function resetResults
  map outputs
end

function __bodyOf
  set -l func $argv[1]
  echo (functions $func | grep -v '^#' | sed -E 's/$/;/')
end
