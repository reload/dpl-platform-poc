#!/usr/bin/env bash
#
#
set -euo pipefail

IFS=$'\n\t'

if [[ $# -lt 2 ]] ; then
    echo "Syntax: $0 <terraform setup name> <dnsimple api key> [increment]"
    exit 1
fi

TF_SETUP_NAME=$1
API_KEY=$2
INC="${3:-001}"

# The Subscription we'll use for everything
SUBSCRIPTION_ID="3b95f745-ffb4-4ff8-b3f9-45308d6fc4b8"

KEYVAULT_NAME="kv-${TF_SETUP_NAME}-${INC}-tfstate"

echo "Adding the key to the ${KEYVAULT_NAME} keyvault..."
az keyvault secret set --subscription "${SUBSCRIPTION_ID}" --name dnsimple-api-key --value "${API_KEY}" --vault-name "${KEYVAULT_NAME}"
