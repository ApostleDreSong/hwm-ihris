#!/bin/bash

# Initialize default values
state=""
platform=""

# Parse command-line options
while getopts ":s:p:" opt; do
  case $opt in
    s)
      state="$OPTARG"
      ;;
    p)
      platform="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check if the service name argument is provided
if [ -z "$state" ]; then
  echo "Name of state is required as an argument"
  exit 1
fi

if [ -z "$platform" ]; then
  echo "Platform is required as an argument"
  exit 1
fi

./create_state_server.sh $state

./create_state_container.sh $state

cd $platform
./start_$state.sh
