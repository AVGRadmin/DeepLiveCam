# Makefile to download and set up models

## CUDA
CUDA_VERSION := "12.2"

MODEL_DIR := models
INSIGHTFACE_DIR := $(MODEL_DIR)/.insightface/models/buffalo_l
MODEL_URL := https://huggingface.co/AVGRadmin/model-pool
# Args
SERVICE ?= Deep-Live-Cam
IMAGE ?= deep-swap:latest-cuda-$(CUDA_VERSION)
# Targets
.PHONY: clean clean-all all setup_models run reset-models

all: clean setup_models run

reset-models: clean setup_models
	
run: 
	docker compose run Deep-Live-Cam

clean: owner
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
build:
	docker build -t $(IMAGE) ./docker/Dockerfile.$(CUDA_VERSION)
	
