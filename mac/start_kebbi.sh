#!/bin/bash

# Service name from the argument
state="kebbi"

# run the start script

./spin_up.sh -p 3003 -f 8084 -e 9203 -k 5604 -r 6383 -s $state