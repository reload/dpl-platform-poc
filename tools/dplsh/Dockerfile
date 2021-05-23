# List of available tags can be found here
# https://mcr.microsoft.com/v2/azure-cli/tags/list
ARG AZURE_CLI_TAG=latest
ARG DPLSH_BUILD_VERSION=latest


# We use the official azure cli as a base-image. It is itself based on alpine
# and is quite minimal.
FROM mcr.microsoft.com/azure-cli:$AZURE_CLI_TAG
ARG TASK_VERSION=v3.0.0
ARG TERRAFORM_RELEASE=0.15.1
ARG HELM_VERSION=canary
ARG HELM_BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ARG HELM_TAR_FILE="helm-${HELM_VERSION}-linux-amd64.tar.gz"
LABEL org.opencontainers.image.source https://github.com/reload/dpl-platform-poc

SHELL ["/bin/bash", "-ox", "pipefail", "-c"]
WORKDIR /tmp

# TODO - this will install the latest version - we should pin to the version we
# actually use.
RUN az aks install-cli
RUN apk add --no-cache \
  ca-certificates \
  rsync \
  vim \
  gettext \
  bash-completion \
  docker-cli

# Add task, a modern Make equivalent.
RUN curl -sL https://taskfile.dev/install.sh | bash -s -- -b /usr/local/bin ${TASK_VERSION}

WORKDIR /tmp

# Add Terraform
RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_RELEASE}/terraform_${TERRAFORM_RELEASE}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_RELEASE}_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_${TERRAFORM_RELEASE}_linux_amd64.zip

# Add Helm
RUN apk add --update --no-cache curl ca-certificates wget && \
    curl -L ${HELM_BASE_URL}/${HELM_TAR_FILE} | tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64 && \
    apk del curl && \
    rm -f /var/cache/apk/*

# Create a dplsh user and switch to it to avoid running the shell as root
RUN adduser -D --shell /bin/bash dplsh

# We do this so that dplsh will be able to access /var/run/docker.sock
RUN chown dplsh /run && chgrp dplsh /run && chmod g+s /run

RUN echo "${DPLSH_BUILD_VERSION}" > /etc/dplsh.version

USER dplsh
WORKDIR /home/dplsh

# Append our profile to the current one.
COPY files/dot.profile.sh /tmp/.profile.tmp
RUN cat /tmp/.profile.tmp >> /home/dplsh/.profile

# Entrypoint will copy mounted .azure-host to this dir if available
RUN mkdir /home/dplsh/.azure

# Place a copy of dplsh.sh in the image to support bootstrapping without
# installation.
# We have a tendency to mess around with this file during local development, so put it last
USER root
RUN mkdir /opt/dplsh
COPY dplsh.sh /opt/dplsh/

# Setup the entrypoint.
COPY files/dplsh-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/dplsh-entrypoint.sh
ENTRYPOINT [ "dplsh-entrypoint.sh"]

USER dplsh
