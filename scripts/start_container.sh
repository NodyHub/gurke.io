#!/bin/bash

. $(dirname "$0")/CONFIG

sudo docker build -t rtl $GIT_BASE/gurke.io/docker/
sudo docker run \
    --rm \
    -d \
    -v $DATA_DIR:/data/ \
    --device=/dev/bus/usb \
    rtl

exit 0
