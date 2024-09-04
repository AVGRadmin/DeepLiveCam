# Repository Overview
This repository is designed as an overhead solution to run various forks of [Deep-Live-Cam](https://github.com/hacksider/Deep-Live-Cam), one at a time, using [Docker](https://www.docker.com/products/docker-hub/). It contains all the necessary configurations and scripts to streamline the setup, build, and execution processes for different forks of the [Deep-Live-Cam](https://github.com/hacksider/Deep-Live-Cam). 
## Docker
### Dockerfile: 
A Dockerfile optimized for building Docker images with CUDA version 12.2 support. This ensures compatibility with the GPU resources required by the application.

### Docker Compose File: 
A Docker Compose configuration that allows you to manage and switch between different forks of the application seamlessly. Each fork is defined as a service, making it easy to add or switch forks by modifying the Docker Compose file.

### Makefile
A Makefile that automates common tasks such as downloading and setting up models, building Docker images, and running the application. The Makefile is designed to be flexible, allowing users to specify which service (fork) and Docker image to use without modifying the Makefile itself.

## Repository Structure
### docker-compose.yml
#### services: 
- Defined in the Docker Compose file, each service corresponds to a different fork of the application. Users can switch between services by specifying the desired service name when running the Makefile.

#### x-base: 
- A shared configuration in the Docker Compose file that defines the base image, build context, volume mappings, GPU reservations, and runtime settings.

#### volumes: 
- The volumes section ensures that necessary scripts, models, and output directories are properly mapped to the Docker containers, allowing seamless data management across different services.

## Makefile: 
The Makefile includes commands to clean up directories, download and set up models, build the Docker image, and run the application using the specified service. Users can specify the service and image directly when executing commands, adding flexibility to the setup.

### Usage
#### Setting Up Models:

- Run `make setup_models` to download and set up the necessary models for the application. This command clones the model repository and prepares the models for use.
#### Running the Application:

- To run the application using the default service (Deep-Live-Cam), simply use the command:
```bash
Copy code
make run
```
- To run the application with a different service, specify the service name like so:
```bash
Copy code
make run SERVICE=iRoopDeepFaceCam
```
#### Building the Docker Image:

- To build the Docker image with the specified CUDA version, use the make build command. You can also specify a different image name if needed:
```bash
Copy code
make build [IMAGE=<image_name>]
```
#### Cleaning Up:
- Use `make clean` to clean up the models and temporary files.
- Use `make clean-all` to purge all output files generated during the application run.
#### Resetting Models:
- If you need to reset the models, you can use the `make reset-models` command, which will clean up and re-download the models.
## Adding New Forks
To add a new fork, you only need to:
1. Define the new service in the Docker Compose file.
2. Specify the service name when running the Makefile commands, as shown in the examples above.
This setup makes it easy to experiment with various forks of the application, allowing for quick changes and minimal configuration effort.

## Dependencies

To use this repository effectively, ensure that your environment meets the following dependencies:

- Docker: You need to have Docker installed on your system. Docker is used to containerize the application and its dependencies. You can install Docker from the official Docker website.

- Docker Compose: Docker Compose is required to manage multi-container Docker applications. It allows you to define and run multi-container Docker applications. Ensure Docker Compose is installed alongside Docker.

- NVIDIA Container Toolkit: If you plan to leverage GPU resources, you need to install the NVIDIA Container Toolkit. This toolkit allows Docker to access the GPU on your system. Installation instructions are available on NVIDIA's official website.
    - Note: It is quite possible to use other cuda versions by editing the Dockerfile, but you will probably run into other dependencies that you'll have to fix.

- Git: Git is required to clone the model repository and manage version control for this project. Ensure Git is installed on your system.

- A CUDA-compatible GPU: Since the application is designed to utilize CUDA, you need a GPU that supports CUDA, along with the appropriate drivers installed on your system.

- Make sure all these dependencies are installed and properly configured before running the application.
