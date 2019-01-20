#!/bin/bash

sudo docker build -t rtl ../docker/
sudo docker run \
    --rm \
    -d \
    -v /home/pi/data:/data/ \
    --device=/dev/bus/usb/001/004 \
    rtl

exit 0
