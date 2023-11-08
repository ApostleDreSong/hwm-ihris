#!/bin/bash

# Service name from the argument
state="bauchi"

# run the start script

./spin_up.sh -p 3000 -f 8081 -e 9200 -k 5601 -r 6380 -s $state