# Use the official OSRF ROS Melodic image as base
FROM osrf/ros:melodic-desktop

# Build arguments for UID, GID, USER, and PROJECT_NAME
ARG PROJECT_UID
ARG PROJECT_GID
ARG PROJECT_USER
ARG PROJECT_NAME

# Install necessary tools and dependencies as root
RUN apt-get update && apt-get install -y \
    git \
    sudo \
    ros-melodic-catkin \
    ros-melodic-catch-ros \
    libqt4-dev \
    libboost-all-dev \
    python-catkin-tools

# Create a new user and group with matching UID and GID
RUN groupadd -g $PROJECT_GID $PROJECT_USER && \
    useradd -m -u $PROJECT_UID -g $PROJECT_GID -s /bin/bash $PROJECT_USER && \
    usermod -aG sudo $PROJECT_USER

# Allow the new user to use sudo without a password
RUN echo "$PROJECT_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Fix rosdep init issue: Create the necessary directory, delete the existing file if it exists, and run rosdep init as root
RUN mkdir -p /etc/ros/rosdep/sources.list.d && \
    if [ -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then sudo rm /etc/ros/rosdep/sources.list.d/20-default.list; fi && \
    sudo rosdep init

# Switch to the new user
USER $PROJECT_USER
WORKDIR /home/$PROJECT_USER

# Run rosdep update as the new user
RUN rosdep update

# Set up a workspace
RUN mkdir -p /home/$PROJECT_USER/$PROJECT_NAME/src
WORKDIR /home/$PROJECT_USER/$PROJECT_NAME

# Copy the entire workspace into the Docker image
COPY --chown=$PROJECT_UID:$PROJECT_GID . /home/$PROJECT_USER/$PROJECT_NAME

# Install dependencies with rosdep as the new user
RUN rosdep install --from-paths src --ignore-src -r -y

# Build the workspace using catkin build as the new user
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin build"

# Source the workspace by default for the new user
RUN echo "source /opt/ros/melodic/setup.bash" >> /home/$PROJECT_USER/.bashrc
RUN echo "source /home/$PROJECT_USER/$PROJECT_NAME/devel/setup.bash" >> /home/$PROJECT_USER/.bashrc

# Expose ROS master port
EXPOSE 11311

# Start with a bash terminal
CMD ["bash"]
