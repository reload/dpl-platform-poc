#!/usr/bin/env bash
set -euxo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# -lt 1 ]] ; then
    echo "Syntax: $0 <ingress-ip> <resource-group>"
    exit 1
fi

INGRESS_IP=$1
RESOURCE_GROUP=$2

# Install Ingress Helm charts.
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx \
&& helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --set controller.replicaCount=2 \
    --set controller.service.loadBalancerIP="${INGRESS_IP}" \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"="false" \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-resource-group"="${RESOURCE_GROUP}" \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
