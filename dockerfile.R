# build R image in Jupyter
# Distributed under the terms of the Modified BSD License.

# Ubuntu 18.04 (bionic) from 2018-04-26
# https://github.com/docker-library/official-images/commit/aac6a45b9eb2bffb8102353c350d341a410fb169
FROM basebook

LABEL maintainer="fcy <feicaiyi@gmail.com>"

USER $NB_UID


# Install conda as ttt and check the md5 sum provided on the download site
#ENV MINICONDA_VERSION 4.5.1

# Install Jupyter Notebook and Hub
RUN $CONDA_DIR/bin/conda install --quiet --yes r r-essentials && \
    $CONDA_DIR/bin/conda clean -tipsy && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions /home/$NB_USER
