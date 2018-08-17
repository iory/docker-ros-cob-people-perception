FROM ros:kinetic

MAINTAINER iory ab.ioryz@gmail.com


RUN mkdir -p /ros_ws/src && \
    cd /ros_ws/src && \
    git clone --depth=1 https://github.com/ipa-rmb/cob_people_perception

RUN cd /ros_ws \
    rosdep update && \
    apt update && \
    rosdep install --from-paths --ignore-src -y -r src && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
                                   python-catkin-tools \
                                   ros-${ROS_DISTRO}-jsk-tools \
                                   ros-${ROS_DISTRO}-map-laser && \
    rm -rf /var/lib/apt/lists/*

RUN mv /bin/sh /bin/sh_tmp && ln -s /bin/bash /bin/sh
RUN source /opt/ros/${ROS_DISTRO}/setup.bash; cd /ros_ws; catkin build
RUN rm /bin/sh && mv /bin/sh_tmp /bin/sh
RUN touch /root/.bashrc && \
    echo "source /ros_ws/devel/setup.bash\n" >> /root/.bashrc && \
    echo "rossetip\n" >> /root/.bashrc && \
    echo "rossetmaster localhost"

COPY ./ros_entrypoint.sh /
COPY ./leg_detector.launch /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
