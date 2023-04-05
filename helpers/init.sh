#!/bin/bash

# Setup git
export GIT_ASKPASS=/app/helpers/git-askpass-helper.sh
export GIT_REPO=$(cat /app/config/workflow_descriptor.json | jq '.repository' | tr -d '"')
git config --global credential.helper cache
git clone $GIT_REPO /app/analysis
touch /app/.irods/irods_environment.json
cat /app/config/workflow_descriptor.json | jq '.irods_environment' >> /app/.irods/irods_environment.json
echo $IRODS_PASSWORD | iinit

if [[ $RUN_MODE = "REPRODUCIBLE" ]]
then
  ./helpers/run.sh
else
  /app/helpers/develop.sh
fi



