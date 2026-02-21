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
helm install istiod istio/istiod --namespace istio-system --set profile=ambient --set meshConfig.accessLogFile=/dev/stdout --wait
# helm install istiod istio/istiod --namespace istio-system --set profile=ambient --set meshConfig.accessLogFile=/dev/stdout --set meshConfig.accessLogEncoding=JSON --set-string values.meshConfig.accessLogFormat="{\"start_time\":\"%START_TIME%\"\,\"method\":\"%REQ(:METHOD)%\"\,\"path\":\"%REQ(:PATH)%\"\,\"protocol\":\"%PROTOCOL%\"\,\"response_code\":\"%RESPONSE_CODE%\"\,\"duration_ms\":\"%DURATION%\"\,\"bytes_sent\":\"%BYTES_SENT%\"\,\"bytes_received\":\"%BYTES_RECEIVED%\"\,\"client_ip\":\"%DOWNSTREAM_REMOTE_ADDRESS%\"\,\"upstream_host\":\"%UPSTREAM_HOST%\"\,\"request_id\":\"%REQUEST_ID%\"}" --wait
echo "🚀 Installing CNI node agent"
helm install istio-cni istio/cni -n istio-system --set profile=ambient --wait
echo "🚀 Installing ztunnel"
helm install ztunnel istio/ztunnel -n istio-system --wait

# ─────────────────────────────────────────────────────────────
# 🚀 Deploy objects
# ─────────────────────────────────────────────────────────────
echo "🚀 Deploying gatewayclass"
kubectl apply -f files/01-gatewayclass.yaml
echo "🚀 Deploying gateway"
kubectl apply -f files/02-gateway.yaml
echo "🚀 Deploying application (ns, httproute, svc, dp)"
kubectl apply -f files/03-application.yaml
sleep 25s

# ─────────────────────────────────────────────────────────────
# ✅ Finished
# ─────────────────────────────────────────────────────────────
echo ""
echo "✅ Application deployed!"

echo "🔗 Please access intranet to: http://localhost:31000"
echo "🔗 Please access internet to: http://localhost:31001"

echo ""
echo "🌍 Intranet Test load"
for i in {1..10}; do curl localhost:31000; done

echo ""
echo "🌍 Intranet Test load with cookies"
# Create first cookie session
curl -c cookies-intranet.txt http://localhost:31000/
# Send the saved cookie
for i in {1..10}; do curl -b cookies-intranet.txt http://localhost:31000/; done

echo ""
echo "🌍 Internet Test load"
for i in {1..10}; do curl localhost:31001; done

echo ""
echo "🌍 Internet Test load with cookies"
# Create first cookie session
curl -c cookies-internet.txt http://localhost:31001/
# Send the saved cookie
for i in {1..10}; do curl -b cookies-internet.txt http://localhost:31001/; done