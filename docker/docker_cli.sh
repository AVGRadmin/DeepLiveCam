#!/bin/bash

### Output paths
root_output="output"
source_dir="${root_output}/source_files" 
target_dir="${root_output}/target_files"
output_dir="${root_output}/output_files"
enhanced_folder="${root_output}/enhanced_files"

# Function to print detailed debug information
debug_info() {
    echo "----- DEBUG INFO -----"
    echo "Timestamp: $(date)"
    echo "Script name: $0"
    echo "User: $(whoami)"
    echo "Current directory: $(pwd)"
    echo "Docker container ID: $(hostname)"

    echo "Environment Variables:"
    echo "MANY_FACES: $MANY_FACES"
    echo "Frame Processor: $frame_processor"
    echo "Max Memory: ${max_mem} GB"
    echo "Threads: $threads"
    echo "Video Encoder: $video_encoder"
    echo "USE_GPU: $USE_GPU"
    echo "USE_VIDEO_ARGS: $USE_VIDEO_ARGS"
    echo "Video Quality: $video_quality"

    echo "Output Paths:"
    echo "Root Output: $root_output"
    echo "Source Directory: $source_dir"
    echo "Target Directory: $target_dir"
    echo "Output Directory: $output_dir"
    echo "Enhanced Folder: $enhanced_folder"
    echo "-----------------------"
}

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
    
    if [[ "${DEBUG}" == true ]]; then
        echo "Running command: $cmd"
    fi

    eval $cmd
    
    if [[ $? -ne 0 ]]; then
        echo "Error: Command failed with exit code $?"
        exit 1
    fi
}

# Startup

## Create workdir folders
mkdir -p "${output_dir}"
mkdir -p "${enhanced_folder}"

if [[ "${DEBUG}" == true ]]; then
    debug_info
fi

## Run app
process_folders
