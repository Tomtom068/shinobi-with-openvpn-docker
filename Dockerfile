ARG BASE_IMAGE=node:current-bookworm-slim
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

ARG SHINOBI_BRANCH=master

RUN groupadd -g 3001 shinobi && \
    useradd -u 3001 -g shinobi -m -s /bin/bash shinobi

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    ffmpeg \
    default-mysql-client \
    procps \
    openvpn \
    gosu \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

RUN git clone --branch $SHINOBI_BRANCH https://gitlab.com/Shinobi-Systems/Shinobi.git /opt/shinobi

WORKDIR /opt/shinobi
RUN npm install && npm install pm2 -g

RUN chown shinobi:shinobi /opt/shinobi


WORKDIR /home/Shinobi

COPY entrypoint-root.sh /entrypoint-root.sh

COPY entrypoint-shinobi.sh /entrypoint-shinobi.sh
RUN chmod a+rx /entrypoint-shinobi.sh
RUN chown shinobi:shinobi /entrypoint-shinobi.sh

EXPOSE 8080

# Switch to the new user for all following layers
#USER 3001:3001

ENTRYPOINT ["/entrypoint-root.sh"]
