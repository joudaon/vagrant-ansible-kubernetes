#!/bin/bash

echo "--> Deploying minikube cluster..."
minikube start --memory 4096
echo "--> Enabling ingress addon..."
minikube addons enable ingress
