#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"

if ! command -v yq &>/dev/null; then
    echo "'yq' is required but not installed. See https://github.com/mikefarah/yq"
    return 1 2>/dev/null || exit 1
fi

read -p "Enter config name (e.g., config_example): " CONFIG_NAME
CONFIG_FILE="$CONFIG_DIR/$CONFIG_NAME.yaml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file $CONFIG_FILE not found."
    return 1 2>/dev/null || exit 1
fi
echo "CONFIG_FILE: $CONFIG_FILE"

echo "==========================================================================="

# yq version is 3.4.3
IMAGE_NAME=$(yq -r '.image_name' "$CONFIG_FILE")
CONTAINER_NAME=$(yq -r '.container_name' "$CONFIG_FILE")
echo "IMAGE_NAME: $IMAGE_NAME"
echo "CONTAINER_NAME: $CONTAINER_NAME"

mount_cmds=""
index=0
while true; do
    src=$(yq -r ".bind_mounts[$index].src" "$CONFIG_FILE")
    dst=$(yq -r ".bind_mounts[$index].dst" "$CONFIG_FILE")
    if [ "$src" == "null" ] || [ "$dst" == "null" ]; then
        break
    fi
    mount_cmds+=" --mount type=bind,src=$src,dst=$dst"
    index=$((index + 1))
done

docker run --gpus all \
           --env NVIDIA_DRIVER_CAPABILITIES=compute,graphics,utility \
           --env NVIDIA_VISIBLE_DEVICES=all \
           --env DISPLAY=$DISPLAY \
           --network=host \
           --volume /tmp/.X11-unix:/tmp/.X11-unix \
           $mount_cmds \
           --name=$CONTAINER_NAME \
           -id \
           --shm-size=16gb \
           $IMAGE_NAME


