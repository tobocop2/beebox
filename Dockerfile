FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    docker.io \
    nodejs \
    npm \
    golang \
    && rm -rf /var/lib/apt/lists/*

RUN npm config set prefix '~/.npm-global' && \
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc

RUN useradd -m -s /bin/bash agent

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER agent
WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
