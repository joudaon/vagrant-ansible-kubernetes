
# Start minikube with insecure registry CIDR
# minikube start --nodes=3
minikube start

# Enable addons
minikube addons enable metrics-server

# Deploy apache-php
kubectl apply -f php-apache.yml

# Create Horizontal Pod Autoscaler
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
