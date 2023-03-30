import json
from snakemake.remote.iRODS import RemoteProvider
from snakemake.utils import min_version
min_version("6.0")
configfile: "/app/config/workflow_descriptor.json"

irods = RemoteProvider(irods_env_file='/app/.irods/irods_environment.json')
files, = irods.glob_wildcards("{files}")
input_files = list(map(lambda file : file["path"], config["inputData"].values()))
output_files = list(map(lambda file : file["path"], config["outputData"].values()))

module analysis_workflow:
  snakefile:
    "analysis/snakefile"
  config: config

use rule * from analysis_workflow

rule all:
  input:
    irods.remote(expand('{f}',f=output_files))

rule validate_data_model_structure:
  input:
    "config/workflow_descriptor.json",
    "analysis/data_model/dgea_input_data_validator.yaml"
  output:
    temporary(touch("validation.done"))
  shell: 
    "linkml-validate -s {input[1]} {input[0]}"
