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

terraform {
  backend "azurerm" {
    resource_group_name  = "test-blob-rg"
    storage_account_name = "tf-state-storage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

variable "imagebuild" {
  type = string
  default = ""
  description = "Image latest"
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
    image  = "devdom/weather-app:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

}


