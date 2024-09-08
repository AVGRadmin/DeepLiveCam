#!/bin/bash

# Define the input folder
input_folder="./output/target_files"
output_folder="./output/target_files/splitted"

lenght=10
# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Loop over each video file in the input folder
for input_file in "$input_folder"/*; do
  # Get the base name of the file (without path and extension)
  base_name=$(basename "$input_file")
  base_name="${base_name%.*}"

  # Use ffmpeg to split the file into 2-minute clips
  ffmpeg -i "$input_file" -c copy -map 0 -segment_time $lenght -f segment -reset_timestamps 1 "$output_folder/${base_name}_part%03d.mp4"
done
