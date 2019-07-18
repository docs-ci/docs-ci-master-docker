FROM jenkins/jenkins:2.164.2

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

#Basic and maven
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
RUN $CONDA_DIR/bin/conda install docsteady

# Adding conda and python to the bin
RUN ln -sf $CONDA_DIR/bin/conda /usr/bin/conda
RUN ln -sf /usr/local/bin/python3 /usr/bin/python

WORKDIR /var/jenkins_home
USER jenkins
