#!/bin/bash

# Check if the service name argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <state_name>"
  exit 1
fi

# Service name from the argument
state_name="$1"

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source file (zipped archive)
source_file="$current_dir/ihris/ihris-backend/site/"

# Destination directory
destination_dir="$current_dir/ihris/ihris-backend/$state_name/"

mkdir -p $destination_dir


# Copy the zipped file to the destination directory
cp -a $source_file $destination_dir
# Unzip the copied source file to the destination directory

