#!/bin/bash

# Settings

## General
### Output paths
root_output="output"
source_dir="${root_output}/source_files" 
target_dir="${root_output}/target_files"
output_dir="${root_output}/output_files"
enhanced_folder="${root_output}/enhanced_files"

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

# Use when processing in no-UI mode
process_folders() {
    local cmd="python3 run.py \
        -sf \"${source_dir}\" \
        -tf \"${target_dir}\" \
        -o \"${output_dir}\" \
        --frame-processor ${frame_processor} \
        --execution-threads ${threads} \
        --max-memory ${max_mem}"

    if [[ "${USE_VIDEO_ARGS}" == true ]]; then
        cmd+=" --video-encoder ${video_encoder} --video-quality ${video_quality} --keep-fps --keep-audio"
    fi

    if [[ "${MANY_FACES}" == true ]]; then
        cmd+=" --many-faces"
    fi
    if [[ "${USE_GPU}" != false ]]; then
        cmd+=" --execution-provider ${USE_GPU}"
    fi
    eval $cmd
}

# Use when processing in no-UI mode
ui() {
    local cmd="python3 run.py \
        --execution-threads ${threads} \
        --max-memory ${max_mem}"

    if [[ "${USE_VIDEO_ARGS}" == true ]]; then
        cmd+=" --video-encoder ${video_encoder} --video-quality ${video_quality}"
    fi

    if [[ "${MANY_FACES}" == true ]]; then
        cmd+=" --many-faces"
    fi
    if [[ "${USE_GPU}" != false ]]; then
        cmd+=" --execution-provider ${USE_GPU}"
    fi
    eval $cmd
}

# Startup

## Create workdir folders
mkdir -p "${output_dir}"
mkdir -p "${enhanced_folder}"

## Run app
ui
