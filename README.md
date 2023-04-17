# Description
This Docker container serves as an environment for reproducible data analysis workflows. The image has been designed to be used in remote environments such as a Kubernetes cluster, to facilitate reproducibility and be used in automated pipelines.

## How to use
### Build
In the root directory of this repo run:
    docker build ./ -t <container_name>:<tag>
### Modify dependencies
#### Dockerfile
It is possible to include packages/dependencies by directly modifying the Dockerfile. 
Only do this if the package/dependency is not available via conda/mamba.
For details see: https://docs.docker.com/engine/reference/builder/ 
#### conda/mamba
The preferred way of adding dependencies.
Just install packages via conda/mamba to an environment, activate the environment and then serialize the environment to a file with the following command:
    conda env export > <environment_name>.yml
Afterwards, move the resulting file to the /deps/conda_envs directory and rebuild the container. The environments will then be available inside the container.
### Jupyterlab
This container has two modes, DEVELOPMENT and REPRODUCIBLE.  Development is the default. In this mode, after startup, the container will start jupyterlab on port 8888.
