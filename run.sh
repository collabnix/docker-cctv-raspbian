#!/bin/sh

IMAGE_NAME=collabnix/docker-cctv-raspbian
VIDEO_DIRECTORY=`pwd`/videos

mkdir -p $VIDEO_DIRECTORY
docker run -d --device=/dev/video0:/dev/video0 -v $VIDEO_DIRECTORY:/mnt/motion -p 8081:8081 $IMAGE_NAME
