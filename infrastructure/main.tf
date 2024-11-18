resource "azurerm_resource_group" "rg" {
    name = var.rgName
    location = var.location
}

module "nak8s-clusterme" {
  source = "./modules/k8s-cluster"
  clusterName = var.clusterName
  rgName = var.rgName
  acr-id = module.containerregistrt.arc-id
  env = var.env
  kv-name = var.kv-name
  ssh_key_name = var.ssh_key_name
  depends_on = [ azurerm_resource_group.rg ]


}

module "containerregistrt" {
  source = "./modules/containerregistry"
  rgName = var.rgName
  acrName = var.acrName
}

module "monitoring" {
    source = "./modules/monitoring"
    rgName = var.rgName

  
}

