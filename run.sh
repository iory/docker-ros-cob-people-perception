#!/bin/bash

docker run -it --rm \
       --net=host \
       iory/docker-cob-people-detection:kinetic \
       /bin/bash -i -c 'roslaunch leg_detector.launch'
