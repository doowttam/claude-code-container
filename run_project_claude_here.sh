#!/bin/bash
set -e

DIR_HASH=$(echo -n "$(pwd)" | md5sum | awk '{print $1}')
IMAGE_NAME="localhost/project-claude-${DIR_HASH}"

WORKSPACE_MOUNT="${WORKSPACE_MOUNT:-$(pwd)}"

echo "Running $IMAGE_NAME..."
echo "Binding $WORKSPACE_MOUNT to /workspace"

# We bind mount .claude, make it, but warn the user
CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-${HOME}/.claude}"
if [[ ! -d $CLAUDE_CONFIG_DIR ]]; then
    echo "Creating $CLAUDE_CONFIG_DIR" >&2
    mkdir -p "$CLAUDE_CONFIG_DIR"
fi

# https://developers.redhat.com/articles/2025/04/11/my-advice-selinux-container-labeling
# Not ideal, but relabeling arbitrary files can have effects beyond the scope of this container
if selinuxenabled 2>/dev/null; then
    echo "Warning: disabling SELinux separation so container can access your files without relabeling them." >&2
fi

podman run \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    --security-opt=label=disable \
    --userns=keep-id:uid=1000,gid=1000 \
    -it \
    --mount type=volume,source=claude-code-bashhistory,target=/commandhistory \
    --volume "$WORKSPACE_MOUNT":/workspace \
    --volume "$CLAUDE_CONFIG_DIR":/home/node/.claude \
    "$IMAGE_NAME" "$@"
