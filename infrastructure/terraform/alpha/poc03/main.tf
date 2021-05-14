variable "location" {}

module "dev_cluster" {
    source       = "./main"
    env_name     = "dev"
    cluster_name = var.cluster_name
}

module "prod_cluster" {
    source       = "./main"
    env_name     = "prod"
    cluster_name = var.cluster_name
}