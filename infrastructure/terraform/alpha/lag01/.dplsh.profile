set +x
echo "Unlocking terraform state...."
export ARM_ACCESS_KEY=$(az keyvault secret show --subscription "3b95f745-ffb4-4ff8-b3f9-45308d6fc4b8" --name tfstate-storage-key --vault-name kv-alpha-005-tfstate --query value -o tsv)
export DNSIMPLE_TOKEN=$(az keyvault secret show --subscription "3b95f745-ffb4-4ff8-b3f9-45308d6fc4b8" --name dnsimple-api-key --vault-name kv-alpha-005-tfstate --query value -o tsv)
export DNSIMPLE_ACCOUNT="61014"
terraform init
echo "Switching to terraform workspace lag01"
terraform workspace select lag01 2> /dev/null || terraform workspace new lag01
