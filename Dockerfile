FROM jenkins/jenkins:2.235.1

# Plugins for better UX 
RUN /usr/local/bin/install-plugins.sh ansicolor \
    && /usr/local/bin/install-plugins.sh greenballs \
    && /usr/local/bin/install-plugins.sh simple-theme-plugin

# install Notifications and Publishing plugins
RUN /usr/local/bin/install-plugins.sh email-ext \
    && /usr/local/bin/install-plugins.sh mailer \
    && /usr/local/bin/install-plugins.sh slack

# Plugin for scaling Jenkins agents
#RUN /usr/local/bin/install-plugins.sh kubernetes

# installing other plugins
RUN /usr/local/bin/install-plugins.sh job-dsl \
    && /usr/local/bin/install-plugins.sh swarm \
    && /usr/local/bin/install-plugins.sh groovy \
    && /usr/local/bin/install-plugins.sh authorize-project \
    && /usr/local/bin/install-plugins.sh snakeyaml-api

#USER root
#
#RUN apt-get update && apt-get -y install groovy

WORKDIR /var/jenkins_home
USER jenkins
