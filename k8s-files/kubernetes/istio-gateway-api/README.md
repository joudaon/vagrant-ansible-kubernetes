# istio ambient mode gateway api example

## How to

Run `setup.sh` script to create Kind Cluster, install Gateway API and example applications.

Run `delete.sh` script to delete everything.

## Architecture

![resource-model](resource-model.png)

## Description

This project implements **Istio Ambient Mode** using the official Helm charts from [ArtifactHub](https://artifacthub.io/packages/helm/istio-official) for a modern, sidecar-free service mesh:

- [Istio Base](https://artifacthub.io/packages/helm/istio-official/base) – core Istio CRDs and base components  
- [Istiod](https://artifacthub.io/packages/helm/istio-official/istiod) – control plane managing certificates, traffic policies, and mesh configuration  
- [Istio CNI](https://artifacthub.io/packages/helm/istio-official/cni) – node-level network plugin that redirects pod traffic to ztunnels  
- [Istio ztunnel](https://artifacthub.io/packages/helm/istio-official/ztunnel) – lightweight node-level proxy handling mTLS and intra-mesh routing  

---

### What is Istio Ambient Mode?

**Istio Ambient Mode** is a lightweight service mesh mode that eliminates the need for Envoy sidecars in each pod. Instead of injecting proxies per pod, Ambient Mode uses:

- **ztunnel**: intercepts pod traffic at the node level, enforcing **mTLS** (mutual TLS), routing, and policy enforcement without modifying pods.  
- **Istio CNI**: ensures all pod traffic is redirected into ztunnel automatically using iptables.  
- **Envoy Gateways**: L7 HTTP/HTTPS gateways that handle routing, virtual hosts, ingress/egress, and access logging.  
- **Istiod**: the control plane that distributes certificates, applies traffic policies, and configures the mesh.  

This architecture allows pods to remain lightweight while the mesh provides full security and observability.

---

### Ambient Mode with Kubernetes Gateway API

In this setup, traffic is managed declaratively via **Gateway API** resources:

- **Gateway**: defines the entry points for L7 traffic and listens on specific ports.  
- **HTTPRoute**: specifies how requests are routed to services based on hostnames, paths, or headers.  

Traffic flow works as follows:

1. A pod sends a request to another service.  
2. The **Istio CNI** redirects the request to the local **ztunnel**.  
3. **ztunnel** applies **mTLS** and routes the traffic.  
4. If the request matches a **Gateway** and **HTTPRoute**, it passes through the **Envoy Gateway** for L7 routing, virtual host selection, and policy enforcement.  
5. The destination pod receives the traffic **without a sidecar**, fully secured and observable.  

---

### Key Benefits

- **Sidecar-free pods** → lower CPU/memory overhead, faster deployments  
- **Automatic mTLS** → secure pod-to-pod communication at the node level  
- **Centralized L7 routing** → via Gateway API and HTTPRoute resources  
- **Observability** → logs, metrics, and telemetry collected at ztunnel and gateways  
- **Simplified CI/CD** → pods remain unchanged while mesh policies are applied  

This approach leverages the **modern Kubernetes Gateway API** for declarative traffic routing while providing a secure, low-overhead service mesh.

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
- [Global mesh options](https://istio.io/latest/docs/reference/config/istio.mesh.v1alpha1/)