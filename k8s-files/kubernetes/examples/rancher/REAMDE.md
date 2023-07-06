# Rancher

## Install rancher

1. Run the following script:

    ```sh
    install.sh
    ```

2. Append minikube ip to `/etc/hosts` file (root is required):

    ```sh
    echo $(minikube ip) myrancherminikube.com >> /etc/hosts
    ```

3. Go to: `https://myrancherminikube.com`.

## Useful links

- [rancher helm repo](https://artifacthub.io/packages/helm/rancher-stable/rancher?modal=install)
- [Install Rancher](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster)