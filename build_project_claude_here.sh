#!/bin/bash
set -e

DIR_HASH=$(echo -n "$(pwd)" | md5sum | awk '{print $1}')
IMAGE_NAME="localhost/project-claude-${DIR_HASH}"

echo "Building $IMAGE_NAME for $(pwd)..."
podman build --no-cache --ssh default -f Dockerfile.claude -t "$IMAGE_NAME" .
