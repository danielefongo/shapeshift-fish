#!/usr/local/bin/fish
set __shapeshift_path (cd (dirname (status -f)); and pwd)

source "$__shapeshift_path/properties"
source "$__shapeshift_path/segment_functions.fish"
source "$__shapeshift_path/map.fish"
source "$__shapeshift_path/exec.fish"

set -U __shapeshift_pid %self

function clearSegments
  set elements $SHAPESHIFT_PROMPT_LEFT_ELEMENTS $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
  for segment in $elements
    set -U __render_$segment ""
  end
end

function preexec --on-event fish_preexec
  if test "$argv[1]" = 'exit'
    return
  end

  clearSegments

  for segment in $SHAPESHIFT_PROMPT_LEFT_ELEMENTS $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
    if test (echo $segment | grep '^async_')
      execAsync $segment __render_$segment
    else
      execSync $segment __render_$segment
    end
  end
end

function fish_prompt
    for segment in $SHAPESHIFT_PROMPT_LEFT_ELEMENTS
        set -l updated (eval echo "\$__render_$segment")

        if test $updated != ""
          printf "$updated "
        end
    end
end

function fish_right_prompt
    for segment in $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
      set -l updated (eval echo "\$__render_$segment")

      if test $updated != ""
        printf " $updated"
      end
    end
end

preexec
