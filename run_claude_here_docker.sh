#!/bin/bash

# Check if SUDO_UID is set (script is run with sudo)
if [ -n "$SUDO_UID" ]; then
    HOST_UID=$SUDO_UID
    HOST_GID=$SUDO_GID
else
    HOST_UID=$(id -u)
    HOST_GID=$(id -g)
fi

# Export ENV variables we use in entrypoint.sh
export HOST_UID HOST_GID

WORKSPACE_MOUNT="${WORKSPACE_MOUNT:-$(pwd)}"

echo "Binding $WORKSPACE_MOUNT to /workspace"

docker run \
    --env HOST_UID \
    --env HOST_GID \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    -it \
    --mount type=volume,source=claude-code-config,target=/home/node/.claude \
    --mount type=volume,source=claude-code-bashhistory,target=/commandhistory \
    --volume "$WORKSPACE_MOUNT":/workspace \
    localhost/claude-code "$@"

