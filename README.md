# Repository Overview
This repository is designed as an overhead solution to run various forks of [Deep-Live-Cam](https://github.com/hacksider/Deep-Live-Cam), one at a time, using [Docker](https://www.docker.com/products/docker-hub/). It contains all the necessary configurations and scripts to streamline the setup, build, and execution processes for different forks of the [Deep-Live-Cam](https://github.com/hacksider/Deep-Live-Cam). 





## NB!
I am mainly using Cuda version 12.2. This is mainly because i have other projects that depends on this version, and its easier for me to rely on that. I will add a dockerfile for cuda 11.8 at a later point. I have an existing [Docker image](https://hub.docker.com/layers/avgradmin/deep-swap/v0.0.6-cuda11.8/images/sha256-322d6fb27b849d691aeb9a962abefb0f597c4463e307a4ab7a5f992d14c482d3?context=repo)
on the hub, but this is from an older deprecated development version and not compatiple with this repo as it is. Only image fully supported is [v0.1.2](https://hub.docker.com/layers/avgradmin/deep-swap/v0.1.2-cuda-12.2/images/sha256-17d70af9e9b3d18a3277b2e079248d1f033354ed6c773e89783863406a6533d8?context=repo) so far.
Note that the original repo is made for cuda 11.8!
## Docker
### Dockerfile: 
A Dockerfile optimized for building Docker images with CUDA version 12.2 support. 
### Docker Compose File: 
A Docker Compose configuration that allows you to manage and switch between different forks of the application seamlessly. Each fork is defined as a service, making it easy to add or switch forks by modifying the Docker Compose file.

### Makefile
The Makefile now handles the environment variables previously managed by the bash script. It automates common tasks such as downloading and setting up models, building Docker images, and running the application. You can specify the service (fork) and Docker image to use without modifying the Makefile itself.

### Environment Variables
The environment variables have been moved from the bash script to the Docker Compose and Makefile, allowing for easier configuration and customization based on your needs.
- `MANY_FACES`: Set to true or false to enable or disable processing of multiple faces.
- `frame_processor`: Set the type of frame processing (e.g., `face_swapper`).
- `max_mem`: Maximum memory allocation for processing.
- `threads`: Number of threads for processing.
- `video_encoder`: Video encoder to use (e.g., `libx265`).
- `USE_GPU`: Set to cuda to enable GPU processing or `false` to disable.
- `USE_VIDEO_ARGS`: Set to `true` or `false` to include additional video processing arguments.
- `video_quality`: Set the video quality level.

## Repository Structure
### docker-compose.yml
- Users can switch between repositories by specifying the desired repo name when adding the volume.
- The volumes section ensures that necessary scripts, models, and output directories are properly mapped to the Docker containers, allowing seamless data management across different services.
## Makefile: 
The Makefile includes commands to clean up directories, download and set up models, build the Docker image, and run the application using the specified service. Users can specify the service and image directly when executing commands, adding flexibility to the setup.

### Usage
<details>
  <summary>video example</summary>
https://github.com/user-attachments/assets/f495c7c6-fd08-405f-b306-2967f67f1e73
</details>

#### Getting existing submodules:
- Run `make submodule-update` to download and set up the DEFAULT repositories for the application. This command clones the repository and prepares them for use.
- Do **not** use if you intend to use other forks.
#### Setting Up Models:
- Run `make setup-models` to download and set up the necessary models for the application. This command clones the model repository and prepares the models for use.
#### Running the Application:

- To run the application using the default repo ([Deep-Live-Cam-Docker](https://github.com/AVGRadmin?tab=repositories)), simply use the command:
```bash
xhost + # Only needed once
```
- ##### UI Mode:
```bash
make ui
```
- ##### CLI Mode:
```bash
make ui
```
- ##### Debug Mode:
`make ui-debug` or `make cli-debug`
#### Settings
<details>
  <summary>docker_script.sh</summary>

#####   Outputs
These settings should be left as they are to ensure compatibility with future docker images. Possibly for changes in my own fork if you intend to use that.
```bash
### Output paths
root_output="output"
source_dir="${root_output}/source_files" 
target_dir="${root_output}/target_files"
output_dir="${root_output}/output_files"
enhanced_folder="${root_output}/enhanced_files"
```
#####   App settings
These are settings you probably wanna play around with and create the best ones for your usage. 
```bash
### Processor
MANY_FACES=false # true/false
frame_processor=face_swapper
## Performance
max_mem=6
threads=4
video_encoder=libx265
USE_GPU=false # Change to cuda or whatever you need to use. 'false' disables.
## Video
USE_VIDEO_ARGS=false # true/false
video_quality=0
```
</details>

#### Building the Docker Image:

- To build the Docker image with the specified CUDA version, use the make build command. You can also specify a different image name if needed:
```bash

make build [IMAGE=<image_name>]
```
#### Cleaning Up:
- Use `make clean` to clean up the models and temporary files.
- Use `make clean-all` to purge all output files generated during the application run.
#### Resetting Models:
- If you need to reset the models, you can use the `make setup_models` command, which will clean up and re-download the models.
## Adding New Forks
To add a new fork, you only need to:
1. Clone the desired fork inside the repo folder.
2. Add the volume in the Docker Compose file.
3. Make sure to have all required models.
4. Start app
   
This setup makes it easy to experiment with various forks of the application, allowing for quick changes and minimal configuration effort.

## Dependencies

To use this repository effectively, ensure that your environment meets the following dependencies:

- Docker: You need to have Docker installed on your system. Docker is used to containerize the application and its dependencies. You can install Docker from the official Docker [website](https://docs.docker.com/engine/install/).

- Docker Compose: Docker Compose is required to manage multi-container Docker applications. It allows you to define and run multi-container Docker applications. Ensure Docker Compose is installed alongside Docker. See [this](https://docs.docker.com/compose/install/).

- NVIDIA Container Toolkit: If you plan to leverage GPU resources, you need to install the NVIDIA Container Toolkit. This toolkit allows Docker to access the GPU on your system. Installation instructions are available on NVIDIA's official website.
    - Note: It is quite possible to use other cuda versions by editing the Dockerfile, but you will probably run into other dependencies that you'll have to fix.
    - Windows users see [this](https://docs.docker.com/desktop/gpu/)

- Git: [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) is required to clone the model repository and manage version control for this project. Ensure Git is installed on your system.

- A CUDA-compatible GPU: Since the application is designed to utilize CUDA, you need a GPU that supports CUDA, along with the appropriate drivers installed on your system.

- Make sure all these dependencies are installed and properly configured before running the application.
