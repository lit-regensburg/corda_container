import json
from snakemake.remote.iRODS import RemoteProvider
configfile: "/app/config/workflow_descriptor.json"

irods = RemoteProvider(irods_env_file='/app/.irods/irods_environment.json')
files, = irods.glob_wildcards("{files}")
input_files = list(map(lambda file : file["path"], config["inputData"].values()))
output_files = list(map(lambda file : file["path"], config["outputData"].values()))

rule all:
  input:
    irods.remote(expand({f},f=output_files)

rule validate_data_model_structure:
  input:
    "workflow_descriptor.json",
    "analysis/data_model/workflow_descriptor_validator.yaml"
  output:
    temporary(touch("validation.done"))
  shell: 
    "linkml-validate -s {input[1]} {input[0]}"

rule do_analysis:
  input:
    "validation.done",
    "analysis/run.sh",
    irods.remote(expand({f}, f=input_files)
  output:
    irods.remote(expand({f}, f=output_files)
  script:
    "analysis/run.sh"

