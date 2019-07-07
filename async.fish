#!/usr/bin/env fish

set caller $argv[1]
set functionName "$argv[2]"
set functionDefinition "$argv[3..-1]"

eval "$functionDefinition"
set -U prompt_$functionName ($functionName)
kill -WINCH $caller
