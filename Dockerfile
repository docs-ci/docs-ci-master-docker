FROM jenkins/jenkins:2.222.3

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

# installing other plugins
RUN /usr/local/bin/install-plugins.sh job-dsl
RUN /usr/local/bin/install-plugins.sh swarm
RUN /usr/local/bin/install-plugins.sh groovy

USER root

#RUN apt-get update && \
#    apt-get -y install apt-transport-https \
#    ca-certificates \
#    curl \
#    gnupg2 \
#    software-properties-common && \
#    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
#    add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
#    $(lsb_release -cs) \
#    stable" && \
#    apt-get update && \
#    apt-get -y install docker-ce
#RUN usermod -a -G docker jenkins

ARG CONDA_DIR="/opt/conda"
ARG MIN_VER="4.7.12"
ARG DS_VER="1.2.rc10_1_g1a75e2a"

# Install Miniconda
RUN mkdir /tmp/miniconda
WORKDIR /tmp/miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-${MIN_VER}-Linux-x86_64.sh
RUN chmod +x Miniconda3-${MIN_VER}-Linux-x86_64.sh
RUN ./Miniconda3-${MIN_VER}-Linux-x86_64.sh -b -p ${CONDA_DIR}

# Add channels
RUN ${CONDA_DIR}/bin/conda config --add channels defaults --system
RUN ${CONDA_DIR}/bin/conda config --add channels gcomoretto --system
#RUN $CONDA_DIR/bin/conda config --add channels conda-forge --system

# Install docsteady
RUN $CONDA_DIR/bin/conda install docsteady=${DS_VER}

# Adding conda bin to the path
ENV PATH /opt/conda/bin:$PATH
RUN conda init bash

WORKDIR /var/jenkins_home
USER jenkins
