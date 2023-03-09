## Requirements

- minikube
- helm

## Setup

1. Run `install.sh` script.

## Stress application

```sh
$> kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```

Check how "php-apache" deployment replicas are being deployed based on cpu usage.

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
- [keda - github](https://github.com/kedacore/keda-docs/blob/main/content/docs/2.0/deploy.md)
- [keda](https://keda.sh/)
- [metrics-server - github](https://github.com/kubernetes-sigs/metrics-server)