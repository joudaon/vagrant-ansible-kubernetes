# istio ambient mode gateway api example

## How to

Run `setup.sh` script to create Kind Cluster, install Gateway API and example applications.

Run `delete.sh` script to delete everything.

## Architecture

![resource-model](resource-model.png)

## Expected Result

After deployment, the following components should be successfully running:

- Two **NodePort Ingresses**:
  - **Intranet** exposure
  - **Internet** exposure  
- Two applications, each deployed with **2 replicas**
  - Each application is exposed through its corresponding ingress scope (intranet or internet)

### Access Points

Both endpoints must be reachable:

- Intranet: http://localhost:31000
- Internet: http://localhost:31001


### Validation Criteria

1. **Connectivity**
   - Both URLs are accessible from the browser or via `curl`.

2. **Load Balancing**
   - Without cookies, requests should be distributed between the two replicas.

3. **Sticky Sessions**
   - When cookies are enabled, repeated requests should consistently reach the same replica, confirming session affinity is working as expected.

If all the above conditions are met, the ingress configuration and sticky session behavior are correctly configured.

```sh
🌍 Intranet Test load
<h1>Pod intranet: iphone-deploy-85bf887d7-pqcv2</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-pqcv2</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-pqcv2</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-pqcv2</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-pqcv2</h1>

🌍 Intranet Test load with cookies
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>
<h1>Pod intranet: iphone-deploy-85bf887d7-r28lh</h1>

🌍 Internet Test load
<h1>Pod internet: iphone-deploy-7547c8c46f-2qdqd</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-2qdqd</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-2qdqd</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-2qdqd</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-2qdqd</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>

🌍 Internet Test load with cookies
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
<h1>Pod internet: iphone-deploy-7547c8c46f-kt4vn</h1>
``` 



## Useful links

- [Gateway API](https://gateway-api.sigs.k8s.io/)
- [Istio install ambient mode (official)](https://istio.io/latest/docs/ambient/install/helm/)
- [ArtifactHub - Istio base](https://artifacthub.io/packages/helm/istio-official/base)
- [ArtifactHub - Istiod](https://artifacthub.io/packages/helm/istio-official/istiod)
- [ArtifactHub - Istio cni](https://artifacthub.io/packages/helm/istio-official/cni)
- [ArtifactHub - Istio ztunnel](https://artifacthub.io/packages/helm/istio-official/ztunnel)
- [ArtifactHub - Istio ambient (umbrella)](https://artifacthub.io/packages/helm/istio-official/ambient)
- [marcel-dempers / docker-development-youtube-series](https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/kubernetes/gateway-api/istio)