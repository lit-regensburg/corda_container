FROM debian
SHELL ["/bin/bash", "-i", "-c"]
RUN groupadd -r swuser -g 433 && \
    useradd -m -u 431 -r -g swuser -c "Docker image user" swuser
RUN adduser swuser sudo

RUN apt update && apt upgrade && apt install curl gpg apt-utils wget lsb-release sudo --assume-yes
RUN curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
RUN install -o swuser -g swuser -m 644 conda.gpg /usr/share/keyrings/conda-archive-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/conda-archive-keyring.gpg] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list
RUN apt update && apt upgrade
RUN apt install conda --assume-yes
RUN apt install r-base --assume-yes

RUN R -e "install.packages('renv')"

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -
RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list
RUN apt update
RUN apt install irods-icommands --assume-yes

WORKDIR /app
RUN mkdir auth
RUN mkdir deps


COPY irods_environment.json .irods/
COPY container_env.yml ./deps
COPY renv.lock ./deps

ENV IRODS_ENVIRONMENT_FILE=/app/.irods/irods_environment.json
# TODO, think about credentials
# RUN iinit rods

ENV PATH /opt/conda/bin:$PATH
RUN echo "swuser:password" | chpasswd
RUN chown -R swuser:swuser /opt/conda
USER swuser
RUN touch ~/.bashrc
RUN conda init bash

RUN conda update conda
RUN echo "conda activate container_env" >> ~/.bashrc
RUN conda install -n base -c conda-forge mamba
RUN conda create --name container_env #create -f ./deps/container_env.yml
RUN mamba install jupyterlab
RUN conda activate container_env && \
  mamba install -c conda-forge -c bioconda snakemake
CMD ["conda", "run", "--no-capture-output", "-n", "container_env", "jupyter-lab", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]

