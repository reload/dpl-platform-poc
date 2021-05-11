# DPL Poc Environments

This documentation describes how the infrastructure for the environments are
handled. We differentiate between the

* An Application environment (eg. "Production" or "Staging")
* "Terraform Setup" meaning a configuration of Terraform that may manage multiple
   application environments.

## Prerequisites
* The Azure CLI [installed](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* Being logged in with a user that has access to the correct azure subscription
  locally (ie. `az login`)

## Bootstrapping Terraform
Each terraform-environment has its own Azure subscription that is used for all
resources provisioned for the environment. The subscription itself has to be
provisioned manually. In order to bootstrap the provisioning of the environment
you need enough access to the subscription to be able to create a
storage-account, a resource group and a key vault.

The bootstrapping is done by running the `bootstrap-tf.sh` tool passing in the
name of the terraform setup. The setup can subsequently be used to provision
any number of environments.

```bash
dplsh terraform/scripts/bootstrap-tf.sh <setup name>

cd environment/env-$ENVIRONMENT_NAME

dplsh
# In dplsh:
terraform init
```

## Setups and Environments
### Alpha setup

Environments:

#### Global
Resources that are global to the resource groups. Eg, any Azure AD resources

#### poc01
Full AKS environment.

TODO: Complete documentation when the environment has been created.
