#!/bin/bash

# Check if the service name argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <state_name>"
  exit 1
fi

# Service name from the argument
state_name="$1"

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker-compose -f "$current_dir/containers/$state_name/docker-compose.yml" up -d
