#!/bin/bash

# Setup git
export GIT_ASKPASS=/app/helpers/git-askpass-helper.sh
git config --global credential.helper cache
git clone $GIT_REPO ./analysis

if [[ $RUN_MODE = "REPRODUCIBLE" ]]
then
  ./helpers/run.sh
else
  /app/helpers/develop.sh
fi


