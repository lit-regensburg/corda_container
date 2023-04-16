#!/bin/bash

CONFIG_PATH="/app/config/workflow_descriptor.json"
CONFIG=$(cat $CONFIG_PATH)
declare -a KEYS=( $(cat $CONFIG_PATH | jq -c -r '.inputData | keys_unsorted | @sh' | tr -d "'") )
for KEY in "${KEYS[@]}"
do
  HASH_PATH=".inputData.$KEY.hash"
  FILE_PATH_JSON=".inputData.$KEY.path"
  HASH=$(echo $CONFIG | jq $HASH_PATH | tr -d '"')
  if [ "$HASH" != "null" ]; then
    FILE_PATH=$(echo $CONFIG | jq $FILE_PATH_JSON | tr -d '"')
    if [ -f "$FILE_PATH" ]; then
      FILE_HASH=$(cat $FILE_PATH | md5sum | awk '{print $1}')
      if [ "$HASH" != "$FILE_HASH" ]; then
        echo "Hashes for file: $FILE_PATH do not match"
        exit 1
      fi
    else 
      echo "Input File at path: $FILE_PATH does not exist"
      exit 1 
    fi
  fi
done
exit 0

