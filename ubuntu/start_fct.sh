#!/bin/bash

# Service name from the argument
state="fct"

# run the start script

./spin_up.sh -p 3002 -f 8083 -e 9202 -k 5603 -r 6382 -s $state