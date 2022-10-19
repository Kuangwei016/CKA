#!/bin/bash

# Create namespace
kubectl create ns app-team1
kubectl create ns internal
kubectl create ns ing-internal

# Create deployment
kubectl apply -f .
# add label
kubectl label nodes node02 disk=ssd
