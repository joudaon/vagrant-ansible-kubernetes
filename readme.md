# Kubernetes Setup Using Ansible and Vagrant
 
## TOC
 
- [Kubernetes Setup Using Ansible and Vagrant](#kubernetes-setup-using-ansible-and-vagrant)
  - [TOC](#toc)
  - [Vagrantfile compatibility versions](#vagrantfile-compatibility-versions)
  - [Useful links](#useful-links)
  - [Useful commands](#useful-commands)
  - [Kubernetes commands](#kubernetes-commands)

## Vagrantfile compatibility versions

| Vagrant version | Virtualbox version                |
| --------------- | --------------------------------- |
| v2.2.4          | Version 6.0.10 r132072 (Qt5.6.2)  |
| v2.2.5          | Version 6.0.10 r132072 (Qt5.6.2)  |
|                 | Version 6.0.10 r132072 (Qt5.9.5)  |

## Useful links

- [Kubernetes Setup Using Ansible and Vagrant](https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/)
- [Using Vagrant/Ansible to spin up a multi-node kubernetes cluster fails detecting kubelet file](https://stackoverflow.com/questions/56998761/using-vagrant-ansible-to-spin-up-a-multi-node-kubernetes-cluster-fails-detecting)
- [Intelligent Vagrant and Ansible files](https://www.simonholywell.com/post/2016/02/intelligent-vagrant-and-ansible-files/)
- [Kubernetes dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
- [Install shell completion](https://docs.docker.com/docker-for-mac/#install-shell-completion)
- [Calico Project](https://www.projectcalico.org/)

## Useful commands

```sh
# Get kubernetes cluster up and ready
$> cd /path/to/Vagrantfile
$> vagrant up
```

```sh
## Accessing master
$> vagrant ssh k8s-master
vagrant@k8s-master:~$ kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
k8s-master   Ready    master   18m     v1.16.3
node-1       Ready    <none>   10m     v1.16.3
node-2       Ready    <none>   2m37s   v1.16.3

## Accessing nodes
$> vagrant ssh node-1
$> vagrant ssh node-2
```

```sh
# Remove kubernetes cluster
$> cd /path/to/Vagrantfile
$> vagrant destroy -f
```

## Kubernetes commands

```sh
# Get Kubernetes version
$> kubectl version
# Get Kubernetes Namespaces
$> kubectl get namespaces
# Get Kubernetes nodes
$> kubectl get nodes
# Running a single pod 
$> kubectl run my-nginx --image nginx
# List pods
$> kubectl get pods
# List all objects
$> kubectl get all
```
