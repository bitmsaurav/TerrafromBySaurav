terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }
}


provider "azurerm" {
  # Configuration options
  features {

  }
  subscription_id = "8a0253d9-8cdd-438f-91ae-002a028d44ab"
}

resource "azurerm_resource_group" "rg" {
    name = "rg-tuple-demo"
    location = "eastus"
  
}
resource "azurerm_virtual_network" "vnet" {
    name="vnet-tuple-demo"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = ["10.0.0.0/16"]
  
}
resource "azurerm_subnet" "subnet" {
    name= var.subnet_info[0]
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.subnet_info[1]]

  
}