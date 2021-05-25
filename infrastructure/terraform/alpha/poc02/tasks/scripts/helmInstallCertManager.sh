#! /bin/bash

# Install cert-manager Helm charts.
helm repo add jetstack https://charts.jetstack.io \
&& helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.3.1 \
  # --set installCRDs=true