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

# Install goose directly in the container
RUN mkdir -p /tmp && \
    curl -fsSL https://github.com/block/goose/releases/download/stable/goose-aarch64-unknown-linux-gnu.tar.bz2 -o /tmp/goose.tar.bz2 && \
    cd /tmp && \
    bunzip2 -f goose.tar.bz2 && \
    tar -xf goose.tar -C /tmp && \
    mv /tmp/goose /usr/local/bin/goose && \
    chmod 755 /usr/local/bin/goose

COPY entrypoint.sh /entrypoint.sh
COPY agents /agents
COPY tools /tools
COPY config.yml /config.yml

RUN chmod +x /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
