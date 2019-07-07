#!/usr/local/bin/fish
set __shapeshift_path (cd (dirname (status -f)); and pwd)

source "$__shapeshift_path/properties"
source "$__shapeshift_path/segment_functions.fish"
set -U __shapeshift_jobs
set -U __shapeshift_pid %self

function execAsync
  set -l elements $SHAPESHIFT_PROMPT_LEFT_ELEMENTS $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
  set -l segment $argv[1]
  if set -l index (contains -i -- $segment $elements)
      kill -9 $__shapeshift_jobs[$index] >/dev/null 2>&1
  end

  set functionBody (functions $segment | grep -v '^#' | sed -e 's/end$/; end/' | sed -E "s/function $segment/function $segment; /")
  "$__shapeshift_path/async.fish" $__shapeshift_pid "$segment" "$functionBody" &

  if set -l index (contains -i -- $segment $elements)
      set -U __shapeshift_jobs[$index] (jobs -l -p)  >/dev/null 2>&1
  end
end

function execSync
  set -l elements $SHAPESHIFT_PROMPT_LEFT_ELEMENTS $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
  set -l segment $argv[1]
  set -U prompt_$segment (eval $segment)
end

function clearSegments
  set elements $SHAPESHIFT_PROMPT_LEFT_ELEMENTS $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
  for segment in $elements
    set -U prompt_$segment ""
  end
end

function preexec --on-event fish_preexec
  if test "$argv[1]" = 'exit'
    return
  end

  clearSegments

  for segment in $SHAPESHIFT_PROMPT_LEFT_ELEMENTS $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
    if test (echo $segment | grep '^async_')
      execAsync $segment
    else
      execSync $segment
    end
  end
end

function fish_prompt
    for segment in $SHAPESHIFT_PROMPT_LEFT_ELEMENTS

        set -l updated (eval echo "\$prompt_$segment")

        if test $updated != ""
          printf "$updated "
        end
    end
end

function fish_right_prompt
    for segment in $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
      set -l updated (eval echo "\$prompt_$segment")

      if test $updated != ""
        printf " $updated"
      end
    end
end

preexec
