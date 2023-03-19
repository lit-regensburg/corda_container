import json
from snakemake.remote.iRODS import RemoteProvider
configfile: "./data_model/dgea_input_data.json"

irods = RemoteProvider(irods_env_file='/home/thimo/.irods/irods_environment.json')
files, = irods.glob_wildcards("{files}")

rule all:
  input:
    irods.remote(config["outputData"]["result"]["path"])

rule validate_data_model_structure:
  input:
    "data_model/dgea_input_data.json",
    "data_model/dgea_input_data_validator.yaml"
  output:
    temporary(touch("validation.done"))
  shell: 
    "linkml-validate -s {input[1]} {input[0]}"

rule do_dgea_analysis:
  input:
    "data_model/dgea_input_data.json",
    "validation.done",
    irods.remote(config["inputData"]["counts"]["path"]),
    irods.remote(config["inputData"]["sample_info"]["path"]),
    "dgea_r/dgea.Rmd"
  output:
    irods.remote(config["outputData"]["result"]["path"])
  script:
    "dgea_r/dgea.Rmd"
