#!/bin/bash


conda run --no-capture-output -n container_env jupyter-lab --no-browser --NotebookApp.token='' --NotebookApp.password=''
