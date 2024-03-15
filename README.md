# tensorflow-gpu-container-demo

## Introduction

This demonstration is created based on Ubuntu 20.04 with NVIDIA® GPU, but the method using VS Code Dev Container should work on any platforms with NVIDIA® GPU driver, NVIDIA® Container Toolkit, and VS Code installed properly.

## Prerequisites

1. [NVIDIA® GPU drivers](https://www.nvidia.com/download/index.aspx?lang=en-us) (required according to [this](https://www.tensorflow.org/install/pip))

   Example of installation commands for Ubuntu using ubuntu-drivers tool (refer to [this](https://ubuntu.com/server/docs/nvidia-drivers-installation) for more details):

   ```shell
   sudo apt install nvidia-driver-535
   ```

2. [NVIDIA® Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (required according to [this](https://github.com/NVIDIA/nvidia-docker/issues/1243))

   Example of installation commands using Apt:

   ```shell
   curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
   ```

   ```shell
   sudo apt-get update
   ```

   ```shell
   sudo apt-get install -y nvidia-container-toolkit
   ```

   Remember to configure the container runtime:

   ```shell
   sudo nvidia-ctk runtime configure --runtime=docker
   sudo systemctl restart docker
   ```

In addition, based on which method you adopt, install the following:

#### Using Docker

Docker engine - example of installation commands using Apt (refer to [this](https://docs.docker.com/engine/install/ubuntu/) for more details):

1. Add Docker's official GPG key:

   ```shell
   sudo apt-get update
   sudo apt-get install ca-certificates curl
   sudo install -m 0755 -d /etc/apt/keyrings
   sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
   sudo chmod a+r /etc/apt/keyrings/docker.asc
   ```

2. Add the repository to Apt sources:

   ```shell
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   sudo apt-get update
   ```

3. Install specific version

   ```shell
   VERSION_STRING=5:25.0.4-1~ubuntu.20.04~focal
   sudo apt-get install -y docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin
   ```

4. Manage Docker as a non-root user

   ```shell
   sudo groupadd docker
   sudo usermod -aG docker $USER
   newgrp docker
   ```

### Using VS Code Dev Container

Related VS Code extensions (basically Docker and Remote Development) - run the following command to install all those directly:

```shell
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-ssh-edit
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension ms-vscode.remote-explorer
code --install-extension ms-vscode.remote-server
```

## Usage

### Using Docker

1. Make sure you are in the directory of the repository:

   ```shell
   cd tensorflow-gpu-container
   ```

2. Build the image:

   ```shell
   docker image build --no-cache -t my_image_name .
   ```

3. Run the container:

   ```shell
   docker run -it --user myuser --network=host --ipc=host --rm --runtime=nvidia --gpus all my_image_name bash
   ```

   Inside the container, go to the workspace directory and run the python script:

   ```shell
   cd workspace/
   ```

   ```shell
   python3 src/demo.py config/my_config.yaml -name trial
   ```

   You should see `Num GPUs Available: 1` in the last line of the output.

### Using VS Code Dev Container

1. Open VS Code
2. Click `Open a Remote Window` button on the left bottom corner
3. Choose `Reopen in Container`
4. Open a new terminal (`Terminal` > `New Terminal`)
5. Run the python script:

   ```shell
   python3 src/demo.py config/my_config.yaml -name trial
   ```

   You should see `Num GPUs Available: 1` in the last line of the output.

6. To work on the Python scripts, you may need to set the interpreter path as `/opt/venv/bin/python`.

## Troubleshooting

### Check if inside virtual environment

Inside the container, run the following command:

```shell
./workspace/check-venv.sh
```

## Issues and Contributing

- Please let me know by filing a new issue
- You can contribute by creating a merge request

## References

- Youtube videos in the [Docker for Robotics](https://youtube.com/playlist?list=PLunhqkrRNRhaqt0UfFxxC_oj7jscss2qe&si=DJsoV8bdb9sBNla1) playlist, particularly:
  - [Docker for Robotics Pt 1 - What and Why??](https://youtu.be/XcJzOYe3E6M?si=RBG0st91x6W4ZwqQ)
  - [Docker 101](https://youtu.be/SAMPOK_lazw?si=C21XBgWSUklJrF7V)
  - [Crafting your Dockerfile (Docker and Robotics Pt 3)](https://youtu.be/RbP5cARP-SM?si=2b9hBJycudqfRRVO)
  - [If you're not developing with this, you're wasting your time](https://youtu.be/dihfA7Ol6Mw?si=ycL2EEmm_EIIJGLh)
- [Luis Sena. 17 May 2021. Creating the Perfect Python Dockerfile. Medium.](https://luis-sena.medium.com/creating-the-perfect-python-dockerfile-51bdec41f1c8)
- [David Elvis. March 20, 2023. How to Install Tensorflow on the GPU with Docker. Saturn Cloud.](https://saturncloud.io/blog/how-to-install-tensorflow-on-the-gpu-with-docker/)
- Github repo [psaboia/devcontainer-nvidia-base](https://github.com/psaboia/devcontainer-nvidia-base)
- Issue [#1735](https://github.com/NVIDIA/nvidia-docker/issues/1735) of github repo [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
- [Itamar Turner-Trauring. Oct 1, 2021. Elegantly activating a virtualenv in a Dockerfile. Python⇒Speed.](https://pythonspeed.com/articles/activate-virtualenv-dockerfile/)
- [28 Feb, 2024. Change the default source code mount. Visual Studio Code.](https://code.visualstudio.com/remote/advancedcontainers/change-default-source-mount)
