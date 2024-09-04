# Makefile to download and set up models

## CUDA
CUDA_VERSION := "12.2"

MODEL_DIR := models
INSIGHTFACE_DIR := $(MODEL_DIR)/.insightface/models/buffalo_l
MODEL_URL := https://huggingface.co/AVGRadmin/model-pool
# Args
SERVICE ?= Deep-Live-Cam
IMAGE ?= deep-swap:latest-cuda-$(CUDA_VERSION)
SUBMODULE_NAME ?= NONE
SUBMODULE_URL ?= NONE
# Targets
.PHONY: clean clean-all all setup_models run reset-models submodule-update

all: clean setup_models submodule-update run

reset-models: clean setup_models
	
run: 
	docker compose run Deep-Live-Cam

clean: 
	sudo chown -R $(USER) .
	rm -rf models model-pool
clean-all: clean
	echo "WARNING: This will purge the output files generated in the output folder! Purge in 5s"
	sleep 2
	rm -rf output/output_files/*
	rm -rf output/enhanced/*
	
setup_models: clean 
	git clone $(MODEL_URL) tmp
	rm -rf models
	mv tmp/models models
	rm -rf model-pool

submodule-update:
	git submodule update --init --recursive

build:
	docker build -t $(IMAGE) ./docker/Dockerfile.$(CUDA_VERSION)

new-submodule:
	git submodule add $(SUBMODULE_URL) $(SUBMODULE_NAME)
	git add .gitmodules $(SUBMODULE_NAME)/
	git commit -m "Added submodule of repo $(SUBMODULE_NAME)"
