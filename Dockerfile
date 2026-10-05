FROM docker.io/library/node:24-trixie-slim

# Install basic development tools and iptables/ipset
RUN apt update && apt install -y less \
  git \
  procps \
  fzf \
  man-db \
  unzip \
  gnupg2 \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  python3 \
  python3-pip \
  python3-dev \
  python3-venv \
  build-essential \
  openssh-client \
  curl

# We use gosu in the entrypoint
# Recommended specifically for changing users in docker
# https://github.com/tianon/gosu?tab=readme-ov-file#gosu
RUN set -eux; \
    apt-get update; \
    apt-get install -y gosu; \
    # Removes apt lists to save space and bust caches
    rm -rf /var/lib/apt/lists/*; \
    # verify that the binary works
    gosu nobody true

# Copy and set up firewall script
COPY resources/init-firewall.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-firewall.sh

# Copy the entrypoint script into the image
COPY resources/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Let the agent know it's in a container
COPY resources/managed_claude.md /etc/claude-code/CLAUDE.md

# Persist bash history.
RUN mkdir /commandhistory && touch /commandhistory/.bash_history
ENV HISTFILE=/commandhistory/.bash_history

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

WORKDIR /workspace

# Set up non-root user
USER node

ENV NODE_OPTIONS="--max-old-space-size=4096"
ENV CLAUDE_CONFIG_DIR=/home/node/.claude
ENV PATH="/home/node/.local/bin:${PATH}"

# Create config directories
RUN mkdir -p /home/node/.claude

# Install Claude
RUN curl -fsSL https://claude.ai/install.sh | bash

USER root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["claude"]
