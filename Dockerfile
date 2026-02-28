FROM node:22-slim

RUN apt-get update && apt-get install -y \
    curl \
    git \
    docker.io \
    golang \
    bzip2 \
    xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && npm cache clean --force

COPY entrypoint.sh /entrypoint.sh
COPY agents /agents
COPY config.yml /config.yml

RUN chmod +x /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
