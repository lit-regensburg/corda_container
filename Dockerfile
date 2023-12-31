FROM debian:bullseye
SHELL ["/bin/bash", "-i", "-c"]
RUN groupadd -r swuser -g 1000 && \
  useradd -m -u 1000 -r -g swuser -c "Docker image user" swuser
RUN adduser swuser sudo

RUN apt update -y && apt upgrade -y && apt install curl gpg apt-utils wget lsb-release sudo git --assume-yes
RUN curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
RUN install -o swuser -g swuser -m 644 conda.gpg /usr/share/keyrings/conda-archive-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/conda-archive-keyring.gpg] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list
RUN apt update -y && apt upgrade -y
RUN apt install conda --assume-yes

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -
RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list
RUN apt update
RUN apt install irods-icommands --assume-yes

WORKDIR /app
RUN mkdir deps
COPY deps deps

ENV IRODS_ENVIRONMENT_FILE=/app/.irods/irods_environment.json

ENV PATH /opt/conda/bin:$PATH
RUN echo "swuser:password" | chpasswd
RUN chown -R swuser:swuser /opt/conda
RUN chown -R swuser:swuser ./
USER swuser
RUN touch ~/.bashrc
RUN conda init bash

RUN conda update conda


RUN conda install -n base -c conda-forge mamba
COPY create_conda_environments.sh ./
RUN conda config --append channels conda-forge
RUN conda config --append channels bioconda
RUN conda config --append channels anaconda
RUN conda config --show channels
USER root
RUN chmod +x create_conda_environments.sh
USER swuser
RUN conda config --show
RUN ./create_conda_environments.sh deps/conda_envs
RUN rm create_conda_environments.sh
RUN echo "conda activate container_env" >> ~/.bashrc
COPY helpers ./helpers
USER root
RUN chmod +x helpers/*
COPY snakefile snakefile
USER swuser
RUN mkdir config
RUN mkdir .irods
RUN mkdir analysis
USER root
RUN apt install -y neovim nano jq
RUN chown -R swuser:swuser /home/swuser/
RUN chown -R swuser:swuser ./
USER swuser
ENTRYPOINT [ "/app/helpers/init.sh" ]

