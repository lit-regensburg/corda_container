#!/bin/bash
source /opt/conda/etc/profile.d/conda.sh
conda activate container_env
./helpers/check_input_file_hashes.sh
snakemake -c 1 -s ./snakefile
