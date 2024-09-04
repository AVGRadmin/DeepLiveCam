#!/bin/bash

## Settings
# Target extentions
target_ext="jpg" # [jpg, png, mp4 ...]
source_ext="jpg" # [jpg, png ...]

# Output paths
root_output="output"
source_dir="${root_output}/source_files" 
target_dir="${root_output}/target_files"
output_dir="${root_output}/output_files"
enhanced_folder="${root_output}/enhanced_files"

## Startup
# Ensure output directory exists
mkdir -p "${output_dir}"
mkdir -p "${enhanced_folder}"

generate_unique_filename() {
    local base_name=$1
    local output_dir=$2
    local output_file="${output_dir}/${base_name}"
    local counter=1

    while [ -e "${output_file}" ]; do
        output_file="${output_dir}/${base_name%.*}_$counter.${base_name##*.}"
        counter=$((counter + 1))
    done

    echo "${output_file}"
}

process_files() {
    for target_file in "${target_dir}"/*.${target_ext}; do
        if [ ! -e "${target_file}" ]; then
            echo "No target files with extension ${target_ext} found in ${target_dir}"
            continue
        fi

        
        base_name=$(basename "${target_file}")
        for input_file in "${source_dir}"/*.${source_ext}; do
            if [ ! -e "${source_dir}" ]; then
                echo "No input files found in ${source_dir}"
                continue
            fi

            input_base_name=$(basename "${input_file}")
            name=$(echo "$input_base_name" | sed "s/.$source_ext/_/g")${base_name}
            # Generate a unique output file name
            output_file=$(generate_unique_filename "${name}" "${output_dir}")
            
            # Run Docker Compose with overridden command
                python3 run.py \
                -s "${input_file}" \
                -t "${target_file}" \
                -o "${output_file}" \
                --execution-provider cuda \
                --frame-processor face_swapper \
                --many-faces \
                --execution-threads 4 \
                --video-encoder libx265 \
                --video-quality 0 \
                --keep-fps \
                --keep-audio \
                --max-memory 8

            # Comment out to skip face enhancing
            echo "Saved to ${output_file}"
                    python3 run.py \
                    -s "${input_file}" \
                    -t "${output_file}" \
                    -o $(generate_unique_filename "${name}" "${enhanced_folder}") \
                    --execution-provider cuda \
                    --frame-processor "face_enhancer" \
                    --execution-threads 4 \
                    --video-encoder libx265 \
                    --video-quality 0 \
                    --keep-fps \
                    --keep-frames \
                    --keep-audio \
                    --max-memory 8
        done
    done
}


process_files 
