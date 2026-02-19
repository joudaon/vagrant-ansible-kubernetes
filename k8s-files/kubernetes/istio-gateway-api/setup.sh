#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────────────────────
# 🎯 Initial configuration
# ─────────────────────────────────────────────────────────────
CLUSTER_NAME="myk8scluster"

# ─────────────────────────────────────────────────────────────
# 🧹 Delete existing cluster (if any)
# ─────────────────────────────────────────────────────────────
echo "🧹 Deleting existing Kind cluster '$CLUSTER_NAME' (if any)..."
kind delete cluster --name "$CLUSTER_NAME" || true

# ─────────────────────────────────────────────────────────────
# 🛠️ Create Kind cluster
# ─────────────────────────────────────────────────────────────
echo "🛠️ Creating '$CLUSTER_NAME' cluster..."
kind create cluster --name "$CLUSTER_NAME" --config kind-cluster.yaml

# ─────────────────────────────────────────────────────────────
# 🛠️ Install Gateway API CRDs
# ─────────────────────────────────────────────────────────────
echo "🛠️ Installing Gateway API CRDs..."
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/standard-install.yaml

# # ─────────────────────────────────────────────────────────────
# # 🚀 Install Istio components (umbrella chart)
# # ─────────────────────────────────────────────────────────────
# # This installs istio components (umbrella chart)
# echo "🚀 Installing Istio components (umbrella chart)..."
# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm install ambient istio/ambient -n istio-system --create-namespace --wait

# ─────────────────────────────────────────────────────────────
# 🚀 Install Istio components one by one
# ─────────────────────────────────────────────────────────────
# Add Istio repo
echo "--> Adding istio repository"
helm repo add istio https://istio-release.storage.googleapis.com/charts
# This installs istio components one by one
echo "🚀 Installing istio base"
helm install istio-base istio/base -n istio-system --create-namespace --wait
echo "🚀 Installing istiod control plane"
# helm show values istio/istiod # view values
# helm pull istio/istiod --untar # optionally untar
helm install istiod istio/istiod --namespace istio-system --set profile=ambient --wait
echo "🚀 Installing CNI node agent"
helm install istio-cni istio/cni -n istio-system --set profile=ambient --wait
echo "🚀 Installing ztunnel"
helm install ztunnel istio/ztunnel -n istio-system --wait
