# Makefile to download and set up models

## CUDA
CUDA_VERSION := "12.2"

MODEL_DIR := models
INSIGHTFACE_DIR := $(MODEL_DIR)/.insightface/models/buffalo_l
MODEL_URL := https://huggingface.co/AVGRadmin/model-pool
# Args
SERVICE ?= Deep-Live-Cam-Multi-Language
IMAGE ?= deep-swap:latest-cuda-$(CUDA_VERSION)
SUBMODULE_NAME ?= NONE
SUBMODULE_URL ?= NONE
# Targets
.PHONY: clean clean-all all setup-models run get-submodules push-latest-submodule-to-git update-git

all: clean setup-models get-submodules run

update-git: push-latest-submodule-to-git

ui: 
	cp ./docker/docker_ui.sh ./output/docker.sh
	docker compose run Deep-Live-Cam 
cli: 
	cp ./docker/docker_cli.sh ./output/docker.sh
	docker compose run Deep-Live-Cam 
ui-debug: 
	cp ./docker/docker_ui.sh ./output/docker.sh
	docker compose run Deep-Live-Cam -e DEBUG=true
cli-debug: 
	cp ./docker/docker_cli.sh ./output/docker.sh
	docker compose run Deep-Live-Cam -e DEBUG=true

clean: 
	sudo chown -R $(USER) .
	rm -rf models tmp

clean-all: clean
	echo "WARNING: This will purge the output files generated in the output folder! Purge in 5s"
	sleep 5
	rm -rf output/output_files/*
	rm -rf output/enhanced/*
	
setup-models: clean 
	git clone $(MODEL_URL) tmp
	rm -rf models
	mv tmp/models models
	rm -rf tmp


build:
	docker build -t $(IMAGE) ./docker/Dockerfile.$(CUDA_VERSION)
get-submodules:
	git submodule update --init --recursive

new-submodule:
	git submodule add $(SUBMODULE_URL) $(SUBMODULE_NAME)
	git add .gitmodules $(SUBMODULE_NAME)/
	git commit -m "Added submodule of repo $(SUBMODULE_NAME)"

push-latest-submodule-to-git:
	cd $(SUBMODULE_NAME)
	git checkout main
	git pull origin main
	cd -
	git add $(SUBMODULE_NAME)
	git commit -m "Update $(SUBMODULE_NAME) to the latest main branch"
	git push origin main

print-debug:
	clear
	@echo "#################################### DEBUG STARTUP"
	@echo ""
	@echo "Latest bash script:"
	@echo '```'
	@cat ./output/docker.sh
	@echo '```'
	@echo ""
	@echo "docker-compose.yml:"
	@echo '```'
	@cat docker-compose.yml
	@echo '```'
	@echo ""
	@echo "makefile:"
	@echo '```'
	@cat makefile
	@echo '```'
	@echo ""
	@echo "#################################### DEBUG DONE"
	@echo ""
	@echo "Copy above message into any issues reported on GitHub!"
