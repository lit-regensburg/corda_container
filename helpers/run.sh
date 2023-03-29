#!/bin/bash
touch /app/.irods/irods_environment.json
cat /app/config/workflow_descriptor.json | jq '.irods_environment' >> /app/.irods/irods_environment.json
echo $IRODS_PASSWORD | iinit
source /opt/conda/etc/profile.d/conda.sh
conda activate container_env
snakemake -c 1 -s ./snakefile
