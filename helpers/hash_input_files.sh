#!/bin/bash
CONFIG_PATH="/app/config/workflow_descriptor.json"
CONFIG=$(cat $CONFIG_PATH)
declare -a KEYS=( $(cat $CONFIG_PATH | jq -c -r '.inputData | keys_unsorted | @sh' | tr -d "'") )
for KEY in "${KEYS[@]}"
do
  FULL_PATH=".inputData.$KEY"
  OLD_ELEMENT=$(echo $CONFIG | jq $FULL_PATH)
  FILE_PATH=$(echo $OLD_ELEMENT | jq '.path' | tr -d '"')
  echo $FILE_PATH
  HASH=$(cat $FILE_PATH | md5sum | awk '{print $1}')
  NEW_ELEMENT=$(echo $OLD_ELEMENT | jq -r --arg HASH "$HASH" '. + {hash: $HASH}')
  CONFIG=$(echo $CONFIG | jq --arg KEY "$KEY" --argjson NEW_ELEMENT "$NEW_ELEMENT" '.inputData[$KEY] |= $NEW_ELEMENT')
done

echo $CONFIG | jq '.' > "/app/workflow_descriptor.json"
