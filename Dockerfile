FROM ubuntu:latest

USER root

ENV \
    HOME="/root" \
    USER_GID=0 \
    WORKSPACE_HOME="/workspace" \
    TINI_VERSION="v0.19.0"

WORKDIR $HOME

# Layer cleanup script
# ADD resources/scripts/item.tar  /usr/bin
COPY --chmod=777 resources/scripts/*  /usr/bin

# install supervisor
RUN \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    wget \
    supervisor && \
    clean-layer.sh
COPY resources/supervisor/ /etc/supervisor/

# install tini
RUN wget --no-verbose --no-check-certificate https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -O /tini && \
    chmod +x /tini
ENTRYPOINT ["/tini", "-g", "--"]
CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]