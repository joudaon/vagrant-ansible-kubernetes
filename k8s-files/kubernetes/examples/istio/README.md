# Istio Service Mesh

## Install istio

```sh
./install.sh
```

## Install addons (kiali, jaeger)

```sh
kubectl apply -f ./${ISTIO_HOME}/samples/addons/
kubectl port-forward svc/kiali 20001:20001 -n istio-system
istioctl dashboard jaeger
```

## Test nginx application

```sh
# Deploy application
kubectl apply -f nginx-example.yaml
# enable minikube tunnel to get loadbalancer ips
minikube tunnel
# Export external load balancer
export INGRESS_HOST=$(kubectl -n loadbalancer-external get service loadbalancer-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}') 
export INGRESS_PORT=$(kubectl -n loadbalancer-external get service loadbalancer-external -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n loadbalancer-external get service loadbalancer-external -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "Load balancer URL: $GATEWAY_URL"
# Curl application 
while true; do curl $GATEWAY_URL; done
# Go to Kiali and see graphs
```

## Enable Load Balancers

```sh
minikube tunnel
```

## Useful information

- [Install Istio Operator](https://istio.io/latest/docs/setup/install/operator/)
- [Istio Operator Init ctl](https://istio.io/latest/docs/reference/commands/istioctl/#istioctl-operator-init)
- [Episode 04: Deploying multiple Istio ingress gateways](https://www.youtube.com/watch?v=QIkryA8HnQ0)
- [Istio ingress traffic on minikube](https://medium.com/codex/setup-istio-ingress-traffic-management-on-minikube-725c5e6d767a)