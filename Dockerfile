FROM jenkins/agent:latest-jdk11
USER root

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# curl
RUN apt-get update &&  \
    apt-get install -y gcc && \
    apt-get install -y curl

# nvm
ENV NVM_DIR /opt/nvm
ENV NODE_VERSION 19.2.0

# node and npm
WORKDIR $NVM_DIR

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

WORKDIR /home/jenkins