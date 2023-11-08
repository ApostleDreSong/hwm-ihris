#!/bin/bash

# # Array of subdomain directories
# subdomains=("bauchi" "ebonyi" "fct" "kebbi" "sokoto")  # Add subdomain names here
# ports=(3000 3001 3002 3003 3004)
# fhirPorts=(8081 8082 8083 8084 8085)
# elasticPorts=(9200 9201 9202 9203 9204)
# kibanaPorts=(5601 5602 5603 5604 5605)
# redisPorts=(6380 6381 6382 6383 6384)

# Array of subdomain directories
subdomains=("ebonyi" "fct")  # Add subdomain names here

for ((index=0; index<${#subdomains[@]}; index++)); do
  subdomain="${subdomains[index]}"
  docker-compose -f "./containers/$subdomain/docker-compose.yml" up -d
  echo "$subdomain started"
done