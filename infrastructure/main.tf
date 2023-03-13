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

resource "azurerm_container_group" "test_cg" {
  name                = "test-container-group"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  ip_address_type     = "Public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

container {
  name   = "weather-app"
  image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
  cpu    = "1"
  memory = "1"

  ports {
    port     = 80
    protocol = "TCP"
  }
}

}


