#!/bin/bash

## Set docker as default driver
minikube config set driver docker

## Start minikube
minikube start --memory 8192 --cpus 4
kubectl apply -f .
kubectl port-forward service/kube-ops-view 8080:80
