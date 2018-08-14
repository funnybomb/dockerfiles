# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Ubuntu 18.04 (bionic) from 2018-04-26
# https://github.com/docker-library/official-images/commit/aac6a45b9eb2bffb8102353c350d341a410fb169
FROM ubuntu:16.04

LABEL maintainer="fcy <feicaiyi@gmail.com>"

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
# install ustc deb

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    apt-utils \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    build-essential \
    emacs \
    vim \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python-dev \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    unzip \
    swig \
    nano \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY tini /usr/local/bin/tini
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    chmod +x  /usr/local/bin/tini

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=fcy \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

ADD fix-permissions /usr/local/bin/fix-permissions
# Create fcy user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN groupadd wheel -g 11 && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

USER $NB_UID

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

# Install conda as fcy and check the md5 sum provided on the download site
ADD Anaconda3-5.2.0-Linux-x86_64.sh /tmp/ana.sh

RUN cd /tmp && \
    #wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    #echo "0c28787e3126238df24c5d4858bd0744 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash ana.sh -f -b -p $CONDA_DIR && \
    $CONDA_DIR/bin/conda clean -tipsy && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
RUN $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    #$CONDA_DIR/bin/conda install --quiet --yes conda=4.5.4 && \
    #$CONDA_DIR/bin/conda update --all --quiet --yes && \
    
    $CONDA_DIR/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    $CONDA_DIR/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    $CONDA_DIR/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    $CONDA_DIR/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/ && \
    $CONDA_DIR/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/ && \
    $CONDA_DIR/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/menpo/ && \
    $CONDA_DIR/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/ && \
    $CONDA_DIR/bin/conda clean -tipsy && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install Jupyter Notebook and Hub
RUN $CONDA_DIR/bin/conda install --quiet --yes \
    'jupyterhub' \
    'jupyterlab' && \
    $CONDA_DIR/bin/jupyter notebook --generate-config && \
    $CONDA_DIR/bin/conda clean -tipsy && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER root

EXPOSE 8888
WORKDIR $HOME

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/
COPY jupyter_notebook_config.json /home/$NB_USER/.jupyter/

RUN fix-permissions /etc/jupyter/ && \
    fix-permissions /home/$NB_USER && \
    rm -f /tmp/ana.sh

# Switch back to fcy to avoid accidental container runs as root
USER $NB_UID
