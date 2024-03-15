# Base image
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# Avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# Create a non-root user
ARG USERNAME=myuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

# Change to non-root user
# USER myuser

# Specific to the application
COPY src /workspace/src/
COPY config /workspace/config/
COPY requirements.txt /workspace/
COPY check-venv.sh /workspace/
COPY entrypoint.sh /workspace/

# Remember to apt-get update before every apt-get install
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    python3.8 \
    python3.8-dev \
    python3.8-venv \
    python3-pip \
    python3-wheel \
	  && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create and source virtual env
ENV VIRTUAL_ENV=/opt/venv
RUN python3.8 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip3 install --upgrade pip \
    && cat /workspace/requirements.txt | xargs -n 1 pip3.8 install --no-cache

# Set up entrypoint and default command
ENTRYPOINT ["/bin/bash", "/workspace/entrypoint.sh"]
CMD ["bash"]

# Better to end with root
USER root
