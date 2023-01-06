## Requirements

- minikube
- helm

## Setup

1. Run `install.sh` script.

## Test apache application

```sh
# enable minikube tunnel to get loadbalancer ips
minikube tunnel
# Export external load balancer
export INGRESS_HOST=$(kubectl -n loadbalancer-external get service loadbalancer-external -o jsonpath='{.status.loadBalancer.ingress[0].ip}') 
export INGRESS_PORT=$(kubectl -n loadbalancer-external get service loadbalancer-external -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n loadbalancer-external get service loadbalancer-external -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "Load balancer URL: $GATEWAY_URL"
# Curl application
while true; do curl $GATEWAY_URL/apache; done
# Curl stikcy session
while true; do curl --cookie "apache=<get cookie id>" $GATEWAY_URL/apache; done
# Go to Kiali and jaeger and see graphs
kubectl port-forward svc/kiali 20001:20001 -n istio-system
istioctl dashboard jaeger
```

## Setup filebeat index on Kibana

1. Go to `Stack Management`.
2. Go to `Kibana > Data Views` and click on `Create data view`.
3. Fulfill `Name` and `Index pattern` with `filebeat-*`.
4. Click `Save data view to Kibana`.

Now you should see logs on `Discover` tab on the left pane.

## Useful information:

- [Github - Elastic Helm charts](https://github.com/elastic/helm-charts)
- [Helm - Kibana](https://artifacthub.io/packages/helm/elastic/kibana#installing)
- [Kubernetes ElasticSearch with Helm minikube](https://www.bogotobogo.com/DevOps/Docker/Docker_Kubernetes_ElasticSearch_with_Helm_minikube.php)
- [Use Helm 3 to Install ELK Stack on Minikube in 10 Mins](https://www.youtube.com/watch?v=ObLXSMfDX1o)
- [Filebeat + Elk Stack Tutorial With Kubernetes](https://www.youtube.com/watch?v=SU--XMhbWoY)
- [minikube start](https://minikube.sigs.k8s.io/docs/commands/start/)
- [Istio monitoring with Elastic Observability](https://www.elastic.co/blog/istio-monitoring-with-elastic-observability)