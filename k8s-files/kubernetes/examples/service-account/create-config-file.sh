#!/bin/bash

# your server name goes here
server=https://192.168.50.10:6443
# the name of the secret containing the service account token goes here
name=jenkins-sa-token-vx6r7

ca=$(kubectl get secret/$name -n jenkins-ns -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name -n jenkins-ns -o jsonpath='{.data.token}' | base64 --decode)
namespace=$(kubectl get secret/$name -n jenkins-ns -o jsonpath='{.data.namespace}' | base64 --decode)

echo "
apiVersion: v1
kind: Config
clusters:
- name: kubernetes
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: jenkins-context
  context:
    cluster: kubernetes
    namespace: ${namespace}
    user: jenkins-sa
current-context: jenkins-context
users:
- name: jenkins-sa
  user:
    token: ${token}
" > sa.kubeconfig