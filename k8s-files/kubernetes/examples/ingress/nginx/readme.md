
## TOC
 
- [TOC](#toc)
- [Useful links](#useful-links)
- [Instructions](#instructions)


## Useful links

- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)

## Instructions

1.  Execute "mandatory.yaml" file: "$> kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml"
2.  Execute "service-nodeport.yaml" file: "$> kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/baremetal/service-nodeport.yaml"
3.  Execute "ingress-example.yaml".
4.  Execute "ingress-rules.yaml".