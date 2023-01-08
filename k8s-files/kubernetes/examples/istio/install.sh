#!/bin/bash

ISTIO_VERSION=1.16.1

## Set docker as default driver
minikube config set driver docker

## Start minikube
minikube start --memory 8192 --cpus 4

## Download istio
curl -L https://istio.io/downloadIstio | sh -

## Install istio. This will create istiod and gateways (load balancers) and install also kiali and jaeger
kubectl create namespace loadbalancer-internal
kubectl create namespace loadbalancer-external
istio-$ISTIO_VERSION/bin/istioctl operator init
kubectl apply -f istio_config/istiocontrolplane.yaml
kubectl apply -f istio_config/ingressgateways.yaml
kubectl apply -f istio-$ISTIO_VERSION/samples/addons/
sleep 10s

