FROM jenkins/jenkins:2.176.2

# Plugins for better UX 
RUN /usr/local/bin/install-plugins.sh ansicolor
RUN /usr/local/bin/install-plugins.sh greenballs
RUN /usr/local/bin/install-plugins.sh simple-theme-plugin

# install Notifications and Publishing plugins
RUN /usr/local/bin/install-plugins.sh email-ext
RUN /usr/local/bin/install-plugins.sh mailer
RUN /usr/local/bin/install-plugins.sh slack


# Plugin for scaling Jenkins agents
#RUN /usr/local/bin/install-plugins.sh kubernetes

USER root

ARG CONDA_DIR="/opt/conda"

# Install Miniconda
RUN mkdir /tmp/miniconda
WORKDIR /tmp/miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x Miniconda3-latest-Linux-x86_64.sh
RUN ./Miniconda3-latest-Linux-x86_64.sh -b -p $CONDA_DIR

# Add channels
RUN $CONDA_DIR/bin/conda config --add channels conda-forge --system
RUN $CONDA_DIR/bin/conda config --add channels gcomoretto --system

# Install docsteady
RUN $CONDA_DIR/bin/conda install docsteady=1.2rc7_0_g09f601e

# Adding conda bin tot he path
ENV PATH /opt/conda/bin:$PATH
RUN conda init bash

WORKDIR /var/jenkins_home
USER jenkins
