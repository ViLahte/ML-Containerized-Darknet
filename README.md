# Object detection with darknet YOLOv4
## Description
- A containerized darknet framework with CUDA support. AlexeyAB's fork of darknet is used.
- Instructions for training and inference with YOLOv4 object recognition network.
- Instructions for configuring YOLOv4 for training on custom datasets *WIP*.
- The weights for the example network which detects dragon heads in images can be found from [here](https://drive.google.com/drive/folders/1-_-UEogMCKSbjYAfzK1_F9Z7aDZLglhJ?usp=sharing).

## Usage

1. Install [Docker](https://docs.docker.com/get-docker/)

2. Configure darknet to compile without cuda support, unless the PC on which the container is running has the [NVIDIA container runtime](https://github.com/NVIDIA/nvidia-container-runtime) installed:

    >Change `use_cuda=1` to `use_cuda=0` in `Dockerfile`

3. Download the [pre-trained weights](https://drive.google.com/file/d/1Dr-47YfU5hi7Qy2YkejC3RwvKYh3lLv4/view?usp=sharing) and place them into the folder `container/weights/`

4. Build and start the docker container:
    ```bash
    docker-compose up -d
    ```
5. Access the jupyterlab environment from
    http://localhost:8888/
6. After done, spin the container down:
    ```bash
    docker-compose down
    ```



![Preview grid](./predictions.jpg)
