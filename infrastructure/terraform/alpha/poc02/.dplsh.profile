echo "Unlocking terraform state...."
export ARM_ACCESS_KEY=$(az keyvault secret show --subscription "3b95f745-ffb4-4ff8-b3f9-45308d6fc4b8" --name tfstate-storage-key --vault-name kv-alpha-005-tfstate --query value -o tsv)
terraform init
echo "Switching to terraform workspace poc02"
terraform workspace select poc02 2> /dev/null || terraform workspace new poc02
export TASK_MODULES_DIR=$HOME/host_mount/task_modules
