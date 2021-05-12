#!/usr/bin/env bash
#
# This scripts bootstraps the terraform setup.
#
# It should only be nessecary to run this script once in the lifetime of the
# a terraform setup (that may manage multipl app-environments).
#
# It sets up a resource-group for terraform, and places a storage-account
# and an keyvault into this group all to be used for managing Terraforms own
# state.
#
set -euo pipefail

IFS=$'\n\t'

if [[ $# -lt 1 ]] ; then
    echo "Syntax: $0 <terraform setup name> <increment>"
    exit 1
fi

INC="${2:-001}"
TF_SETUP_NAME=$1

# Inspired by https://blog.jcorioland.io/archives/2019/09/09/terraform-microsoft-azure-remote-state-management.html
LOCATION="westeurope"
# The Subscription we'll use for everything
SUBSCRIPTION_ID="3b95f745-ffb4-4ff8-b3f9-45308d6fc4b8"
# The resource-group we'll place the setup resources into.
RESOURCE_GROUP="rg-dpl-poc-${TF_SETUP_NAME}-tfstate-${INC}"

# Base names of the resources.
TF_STATE_STORAGE_ACCOUNT_NAME="stdplpoc${TF_SETUP_NAME}tf${INC}"
TF_STATE_CONTAINER_NAME="state"
KEYVAULT_NAME="kv-${TF_SETUP_NAME}-${INC}-tfstate"
BLOB_NAME=${TF_SETUP_NAME}.tfstate

# Create the resource group for holding Terraform resources.
echo "Creating $RESOURCE_GROUP resource group..."
az group create -n "${RESOURCE_GROUP}" -l $LOCATION --subscription "${SUBSCRIPTION_ID}"

echo "Resource group $RESOURCE_GROUP created."

# Create the storage account that will hold the Terraform state.
echo "Creating $TF_STATE_STORAGE_ACCOUNT_NAME storage account..."
az storage account create --subscription "${SUBSCRIPTION_ID}" -g "${RESOURCE_GROUP}" -l "${LOCATION}" \
  --name $TF_STATE_STORAGE_ACCOUNT_NAME \
  --sku Standard_LRS \
  --encryption-services blob

echo "Storage account $TF_STATE_STORAGE_ACCOUNT_NAME created."

# Retrieve the storage account key that Terraform will use to access its state.
echo "Retrieving storage account key..."
ACCOUNT_KEY=$(az storage account keys list --subscription "${SUBSCRIPTION_ID}" --resource-group "${RESOURCE_GROUP}" --account-name "${TF_STATE_STORAGE_ACCOUNT_NAME}" --query [0].value -o tsv)

echo "Storage account key retrieved."

# Create a storage container (for the Terraform State)
echo "Creating $TF_STATE_CONTAINER_NAME storage container..."
az storage container create --subscription "${SUBSCRIPTION_ID}" --name $TF_STATE_CONTAINER_NAME --account-name $TF_STATE_STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "Storage container $TF_STATE_CONTAINER_NAME created."

# Create an Azure KeyVault to hold the storage-account key.
echo "Creating $KEYVAULT_NAME key vault..."
az keyvault create --subscription "${SUBSCRIPTION_ID}" -g "${RESOURCE_GROUP}" -l "${LOCATION}" --name "${KEYVAULT_NAME}"

echo "Key vault ${KEYVAULT_NAME} created."

# Store the Storage Account Key into KeyVault
echo "Store storage access key into key vault secret..."
az keyvault secret set --subscription "${SUBSCRIPTION_ID}" --name tfstate-storage-key --value "${ACCOUNT_KEY}" --vault-name $KEYVAULT_NAME

echo "Key vault secret created."

# Display information to be used for configuering backends for the individual
# Terraform-managed environments.
echo "Azure Storage Account and KeyVault have been created."
echo "Use the following backend configuration for any application-environments"
echo "managed by this terraform setup. Replace <env> with the name of the environment"
echo "--- start ${TF_SETUP_NAME}/<env>/backend.tf  ---"
cat <<EOT
terraform {
  backend "azurerm" {
    storage_account_name = "$TF_STATE_STORAGE_ACCOUNT_NAME"
    container_name       = "$TF_STATE_CONTAINER_NAME"
    key                  = "$BLOB_NAME"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.58.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "${SUBSCRIPTION_ID}"
}

EOT
echo "--- end ${TF_SETUP_NAME}/<env>/backend.tf  ---"
echo "--- start ${TF_SETUP_NAME}/<env>/.dplsh.profile ---"
cat <<EOT
echo "Unlocking terraform state...."
export ARM_ACCESS_KEY=\$(az keyvault secret show --subscription "${SUBSCRIPTION_ID}" --name tfstate-storage-key --vault-name $KEYVAULT_NAME --query value -o tsv)
terraform init
echo "Switching to terraform workspace <env>"
terraform workspace select <env> 2> /dev/null || terraform workspace new <env>

EOT
echo "--- end ${TF_SETUP_NAME}/<env>/.dplsh.profile  ---"

echo ""
echo "Then cd to directory, launch dplsh and perform a \"terraform init\""

