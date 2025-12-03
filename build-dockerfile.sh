#!/usr/bin/env bash

# set -e
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/dockerfiles"

echo "Scanning configs in: $CONFIG_DIR"
CONFIG_NAME=$(
    find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -type d \
        | xargs -n1 basename \
        | fzf --prompt="Select config: " --height=40% --border --reverse \
              --preview="cat $CONFIG_DIR/{}/dockerfile"
)
if [[ -z "$CONFIG_NAME" ]]; then
    echo "No config selected. Abort."
    exit 1
fi
echo "Selected config folder: $CONFIG_NAME"

# read -rp "Enter Dockerfile path (absolute): " DOCKER_FILE
# DOCKER_FILE=/home/charlie/charlie_ws/docker_management/dockerfiles/icpflow/dockerfile
DOCKER_FILE="$CONFIG_DIR/$CONFIG_NAME/dockerfile"

if [[ ! -f "$DOCKER_FILE" ]]; then
    echo "Error: Dockerfile does not exist at $DOCKER_FILE"
    return 1 2>/dev/null || exit 1
fi
echo "DOCKERFILE path: $DOCKER_FILE"

DEPENDENCIES="$(dirname "$DOCKER_FILE")"

# read -rp "Enter image name (e.g., ros2-humble:test): " IMAGE_NAME
IMAGE_NAME=grid-for-polygons:latest

echo "Building image: $IMAGE_NAME"
echo "Dockerfile: $DOCKER_FILE"
echo "Context: $DEPENDENCIES"

docker buildx build --tag $IMAGE_NAME --file $DOCKER_FILE $DEPENDENCIES
