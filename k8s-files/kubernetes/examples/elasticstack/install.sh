#!/bin/bash

IMAGE_VERSION=8.5.1

## Set docker as default driver
minikube config set driver docker

## Start minikube
minikube start --memory 8192 --cpus 4

## Install kube-state-metrics
echo "--> Installing kube-state-metrics"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/master/examples/standard/cluster-role-binding.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/master/examples/standard/cluster-role.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/master/examples/standard/deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/master/examples/standard/service-account.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kube-state-metrics/master/examples/standard/service.yaml

## Install Elasticsearch
echo "--> Installing Elasticsearch with Helm"
helm repo add elastic https://helm.elastic.co
helm repo list
helm install elasticsearch elastic/elasticsearch --values elastic-values.yaml --namespace=elk --create-namespace --wait --set imageTag=$IMAGE_VERSION

##  Install Kibana
echo "--> Installing Kibana with Helm"
helm install kibana elastic/kibana --namespace=elk --wait --set imageTag=$IMAGE_VERSION
kubectl expose deployment kibana-kibana --type=NodePort --name=kibana-service --namespace=elk

##  Install Filebeat
echo "--> Installing Filebeat with Helm"
helm install filebeat elastic/filebeat --namespace=elk --wait --set imageTag=$IMAGE_VERSION

##  Install Metricbeat
echo "--> Installing Metricbeat"
kubectl apply -f metricbeat.yaml --wait=true
sleep 20s
# echo "--> Installing Metricbeat with Helm"
# helm install metricbeat elastic/metricbeat --namespace=elk --wait

## Load Metricbeat dashboards
echo "--> Loading Kibana Dashboards"
METRICBEAT_POD=$(kubectl get pod -n elk | grep metricbeat | awk '{ print $1 }')
kubectl exec -it $METRICBEAT_POD -n elk -- /bin/bash -c "metricbeat setup --dashboards -E output.elasticsearch.hosts=['elasticsearch-master:9200'] -E setup.kibana.host=kibana-kibana:5601"
sleep 10s

# Get credentials
echo "--> Installation finished!"
NODEPORT=$(kubectl get service kibana-service --namespace=elk -ojsonpath='{.spec.ports[0].nodePort}')
ELASTIC_PASSWORD="$(kubectl get secrets --namespace=elk elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d)"
echo "Kibana URL --> $(minikube ip):$NODEPORT"
echo "Kibana username --> elastic"
echo "Kibana password --> $ELASTIC_PASSWORD"

## Export port
# kubectl port-forward deployment/kibana-kibana 5601 -n elk

