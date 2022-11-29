rule all:
  input:
    "./report.nb.html"

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
    "validation.done",
    "data_model/dgea_input_data.json",
    "dgea_r/dgea.Rmd"
  output:
    "./report.nb.html"
  shell:
    "Rscript -e 'rmarkdown::render(\"{input[2]}\", output_file=\"{output}\")'"
    
