#!/bin/bash

# Set the duration in seconds
duration=5

# Loop through all files in the current directory that end with .gif
for file in *.gif; do
  # Use imagemagick to get the original delay of the first frame
  delay=$(identify -format "%T" "${file}[0]")

  # Calculate the number of frames to remove or duplicate
  num_frames=$(identify -format "%n" "${file}")
  desired_frames=$((duration * 100 / delay))
  frame_diff=$((desired_frames - num_frames))
  frame_change=$((frame_diff / 2))

  # Use imagemagick to remove or duplicate frames as necessary
  if (( frame_diff > 0 )); then
    convert -dispose background -delay "${delay}" "${file}" -duplicate "${frame_change}",1 "${file}"
  elif (( frame_diff < 0 )); then
    convert -dispose background -delay "${delay}" "${file}" "${file}"[0-"$((num_frames + frame_diff - 1))]" -delay "${delay}" "${file}"
  fi
done