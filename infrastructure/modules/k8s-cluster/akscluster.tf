

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = var.kv-name
  location            = var.location
  resource_group_name = var.rgName
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  enable_rbac_authorization = true
  public_network_access_enabled = true

  network_acls {
    default_action = "Allow"
    bypass = "AzureServices"
  }
}

resource "azurerm_role_assignment" "kvadmin" {
  scope = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id = "97481bdd-3621-4d84-bdb5-a55a739c3e78"
  
}

# Generate SSH Key Pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Store Private Key in Key Vault as Secret
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "${var.ssh_key_name}-private"
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = azurerm_key_vault.kv.id
}

# Store Public Key in Key Vault as Secret
resource "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "${var.ssh_key_name}-public"
  value        = tls_private_key.ssh_key.public_key_openssh
  key_vault_id = azurerm_key_vault.kv.id
}



resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.clusterName
  location            = var.location
  resource_group_name = var.rgName
  role_based_access_control_enabled = true
  private_cluster_enabled = false
  dns_prefix          = "exampleaks1"
  
    default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
  
 network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    
  }

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = azurerm_key_vault_secret.ssh_public_key.value
    }
  }
  
}

# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id   = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope          = var.acr-id
}



resource "azurerm_kubernetes_cluster_node_pool" "frontendpool" {
  name                  = "pool1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = "Standard_DS2_v2"
  os_type = "Linux"
  node_count            = 1
  auto_scaling_enabled = true
  min_count = 1
  max_count = 2
  node_labels = {
    Environment = var.env
    tier = "frontend"
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "devbackendpool" {
  name                  = "pool2"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = "Standard_DS2_v2"
  os_type = "Linux"
  node_count            = 1
  auto_scaling_enabled = true
  min_count = 1
  max_count = 2
  node_labels = {
    Environment = "Development"
    tier = "backend"
  }

}

