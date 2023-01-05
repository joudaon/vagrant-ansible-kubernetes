#!/bin/bash

# https://istio.io/latest/docs/setup/install/istioctl/#uninstall-istio

# istioctl uninstall --purge
# istioctl operator remove
# kubectl delete namespace istio-system

minikube delete
rm -rf istio-*
