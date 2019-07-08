function map
  set -l mapName $argv[1]
  set -l key $argv[2]
  set -l value $argv[3]

  set -l keyz __map_keys_$mapName
  set -l valuez __map_valuez_$mapName

  if test "$key$value" = ""
    set -U $keyz
    set -U $valuez
  else if test "$key" != "" -a "$value" = ""
    if set -l index (contains -i -- $key $$keyz)
      echo "$$valuez[1][$index]"
    else
      echo
    end
  else if test "$key" != "" -a "$value" != ""
    set -l keys __map_keys_$mapName

    if set -l index (contains -i -- $key $$keyz)
      set -U $valuez[1][$index] "$value"
    else
      set -a -U $keyz $key
      set -a -U $valuez "$value"
    end
  end
end
