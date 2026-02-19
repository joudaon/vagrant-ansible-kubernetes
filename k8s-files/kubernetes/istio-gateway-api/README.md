# istio ambien mode gateway api example

## How to

Run `setup.sh` script to create Kind Cluster, install Gateway API and example applications.

Run `delete.sh` script to delete everything.

## architecture

![resource-model](resource-model.png)

## Useful links

- [Gateway API](https://gateway-api.sigs.k8s.io/)
- [Istio install ambient mode (official)](https://istio.io/latest/docs/ambient/install/helm/)
- [ArtifactHub - Istio base](https://artifacthub.io/packages/helm/istio-official/base)
- [ArtifactHub - Istiod](https://artifacthub.io/packages/helm/istio-official/istiod)
- [ArtifactHub - Istio cni](https://artifacthub.io/packages/helm/istio-official/cni)
- [ArtifactHub - Istio ztunnel](https://artifacthub.io/packages/helm/istio-official/ztunnel)
- [ArtifactHub - Istio ambient (umbrella)](https://artifacthub.io/packages/helm/istio-official/ambient)
- [marcel-dempers / docker-development-youtube-series](https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/kubernetes/gateway-api/istio)