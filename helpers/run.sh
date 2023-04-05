#!/bin/bash
source /opt/conda/etc/profile.d/conda.sh
conda activate container_env
snakemake -c 1 -s ./snakefile
