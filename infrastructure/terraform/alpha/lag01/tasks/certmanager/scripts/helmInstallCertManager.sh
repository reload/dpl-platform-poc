#! /bin/bash

# Install cert-manager Helm charts.
helm repo add jetstack https://charts.jetstack.io \
&& helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.3.1 \
  --set ingressShim.defaultIssuerName=letsencrypt-prod \
  --set ingressShim.defaultIssuerKind=ClusterIssuer \
  --set ingressShim.defaultIssuerGroup=cert-manager.io \
  --set installCRDs=true

# Wait for certmanager to be ready.
kubectl wait \
  --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s
kubectl wait \
  --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=cainjector \
  --timeout=300s
kubectl wait \
  --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=webhook \
  --timeout=300s
