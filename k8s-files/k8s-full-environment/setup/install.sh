#!/bin/bash

## Set docker as default driver
minikube config set driver docker

## Start Minikube
minikube start --addons=dashboard --addons=metrics-server --addons=ingress --addons=registry --cpus=4 --memory=8gb --kubernetes-version=v1.26.3

############
## ARGOCD ##
############

## Install argocd
echo "--> Installing argocd"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl expose deployment argocd-server --type=NodePort --name=argocd-service --namespace=argocd
sleep 30s

## Install External Secrets Operator (https://github.com/external-secrets/external-secrets)(https://github.com/hashicorp/vault-helm/issues/17)
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace --wait

## Install Argo Rollouts
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

## Install Argo CD Image Updater (https://argocd-image-updater.readthedocs.io/en/stable/)
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

## Get credentials
echo "--> ArgoCD Installation finished!"
ARGOCD_NODEPORT=$(kubectl get service argocd-service --namespace=argocd -ojsonpath='{.spec.ports[0].nodePort}')
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

#########
## ELK ##
#########

IMAGE_VERSION=8.5.1

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

## Load Metricbeat dashboards
echo "--> Loading Kibana Dashboards"
METRICBEAT_POD=$(kubectl get pod -n elk | grep metricbeat | awk '{ print $1 }')
sleep 20s
kubectl exec -it $METRICBEAT_POD -n elk -- /bin/bash -c "metricbeat setup --dashboards -E output.elasticsearch.hosts=['elasticsearch-master:9200'] -E setup.kibana.host=kibana-kibana:5601"
sleep 10s

# Get credentials
echo "--> Installation finished!"
ELASTIC_NODEPORT=$(kubectl get service kibana-service --namespace=elk -ojsonpath='{.spec.ports[0].nodePort}')
ELASTIC_PASSWORD="$(kubectl get secrets --namespace=elk elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d)"

##########€##
## RANCHER ##
#############

# Add the Jetstack Helm repository (for cert-manager)
echo "--> Adding rancher repository"
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install the cert-manager Helm chart
echo "--> Installing cert-manager"
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.12.0 \
  --set installCRDs=true \
  --wait

# Add rancher Helm repository
echo "--> Adding rancher repository"
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

echo "--> Installing rancher"
kubectl create namespace cattle-system
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set ingress.tls.source=rancher \
  --set hostname=myrancherminikube.com \
  --set replicas=2 \
  --set bootstrapPassword=admin \
  --version=2.7.5 \
  --wait

echo ""
echo "**** INSTALLATION FINISHED! ****"
echo "--> Check credentials.txt file"

cat <<EOT > credentials.txt
ARGOCD
------
argocd URL --> $(minikube ip):$ARGOCD_NODEPORT
argocd username --> admin
argocd password --> $ARGOCD_PASSWORD

ELK
----
Kibana URL --> $(minikube ip):$ELASTIC_NODEPORT
Kibana username --> elastic
Kibana password --> $ELASTIC_PASSWORD

RANCHER
-------
** Please enter $(minikube ip) into your /etc/hosts file ($> echo $(minikube ip) myrancherminikube.com >> /etc/hosts)
Rancher URL --> https://myrancherminikube.com
Rancher username: admin
Rancher bootstrapPassword: admin

EOT
