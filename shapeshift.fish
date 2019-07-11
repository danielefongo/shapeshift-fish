#!/usr/local/bin/fish
set __shapeshift_path (cd (dirname (status -f)); and pwd)

source "$__shapeshift_path/properties"
source "$__shapeshift_path/segment_functions.fish"
source "$__shapeshift_path/map.fish"
source "$__shapeshift_path/exec.fish"

function preexec --on-event fish_postexec
  if test "$argv[1]" = 'exit'
    return
  end

  resetResults

  for segment in $SHAPESHIFT_PROMPT_LEFT_ELEMENTS $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
    if test (echo $segment | grep '^async_')
      execAsync (echo $segment | sed 's/^async_//')
    else
      execSync $segment
    end
  end
end

function fish_prompt
    for segment in $SHAPESHIFT_PROMPT_LEFT_ELEMENTS
        set -l updated (__obtainValueOf $segment)

        if test $updated != ""
          printf "$updated "
        end
    end
end

function fish_right_prompt
    for segment in $SHAPESHIFT_PROMPT_RIGHT_ELEMENTS
      set -l updated (__obtainValueOf $segment)

      if test $updated != ""
        printf " $updated"
      end
    end
end

function __obtainValueOf
  set -l segment $argv[1]
  set -l originalSegment (echo $segment | sed 's/^async_//')
  echo (resultFor $originalSegment)
end

preexec
