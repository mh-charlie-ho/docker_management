#!/usr/bin/env bash

# set -e
set -u

# read -rp "Enter Dockerfile path (absolute): " DOCKER_FILE
DOCKER_FILE=/home/charlie/charlie_ws/docker_management/dockerfiles/icpflow/dockerfile
if [[ ! -f "$DOCKER_FILE" ]]; then
    echo "Error: Dockerfile does not exist at $DOCKER_FILE"
    return 1 2>/dev/null || exit 1
fi
DEPENDENCIES="$(dirname "$DOCKER_FILE")"

# read -rp "Enter image name (e.g., ros2-humble:test): " IMAGE_NAME
IMAGE_NAME=icp-flow:charlie

echo "Building image: $IMAGE_NAME"
echo "Dockerfile: $DOCKER_FILE"
echo "Context: $DEPENDENCIES"

docker buildx build --tag $IMAGE_NAME --file $DOCKER_FILE $DEPENDENCIES