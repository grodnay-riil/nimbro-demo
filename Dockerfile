# Use the official OSRF ROS Kinetic image as base
FROM osrf/ros:kinetic-desktop

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    git \
    ros-kinetic-catkin \
    ros-kinetic-catch-ros \
    libqt4-dev \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up a workspace
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws

# Clone Nimbro Network
RUN git clone https://github.com/AIS-Bonn/nimbro_network.git src/nimbro_network

# Build the workspace
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

# Source the workspace by default
RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

# Expose ROS master port
EXPOSE 11311

# Start with a bash terminal
CMD ["bash"]
