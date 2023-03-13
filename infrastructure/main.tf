terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "test_rg" {
  name     = "test-rg"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "test_vn" {
  name                = "test-network"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_kubernetes_cluster" "test_aks" {
  name                = "test-aks1"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  dns_prefix          = "testingaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.test_aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.test_aks.kube_config_raw

  sensitive = true
}


