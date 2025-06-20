#!/bin/bash
set -e

# Initializing firewall
/usr/local/bin/init-firewall.sh

# Change uid/gid of node user to match host user based on env variables we pass in
echo "Setting node UID : $HOST_UID, GID: $HOST_GID"
# Change our node user ids, see:
# https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#non-root-user
groupmod -g $HOST_GID node && usermod -u $HOST_UID -g $HOST_GID node

# Set correct permissions for our volumes
chown -R node:node /home/node/.claude /commandhistory

# Switch to the new user and run the command
# gosu seems to be made specifically for docker
# more details here: https://github.com/tianon/gosu?tab=readme-ov-file#gosu
gosu node "$@"
