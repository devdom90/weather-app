terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "test-rg" {
  name = "weather-app-rg"
  location = "West Europe"
}

resource "azurerm_container_group" "test-acg" {
  name                = "w-app-acg-1"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
  ip_address_type     = "Public"
  dns_name_label      = "weather-app"
  os_type             = "Linux"
  container {
    name              = "weatherapp"
    image             = "devdom90/w-app-acg-1"
      cpu               = "1"
      memory            = "1"

      ports {
        port            = 80
        protocol        = "TCP"  
      } 
  }
}