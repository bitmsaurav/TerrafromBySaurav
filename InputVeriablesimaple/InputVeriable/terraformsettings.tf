
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
  subscription_id = "99054a73-fe84-4cb1-bc5e-3a75c9ad9c6b"
}




# resource "azurerm_storage_account" "example" {
#   name                     = "storageaccountname"
#   resource_group_name      = var.rg_name
#   location                 = var.rg_location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"


# }

# # #Template

# # <BLOCK TYPE> "<Block lable>" "<Block labael>"{
# #   # Block body
# #   <Identifier>=<expression> #Arguments
# # }
# resource "azurerm_resource_group" "xyz" {
#     count =length(var.rg_name)
#     name=var.rg_name[count.index]
#     location = "Centerindia"

# }

# resource "azurerm_resource_group" "mithun1" {
#   count    = 4
#   name     = "rg-${count.index}"
#   location = "centralindia"

# }


variable "mithunResousegroup" {
  default = {

    "dev"     = "eastus"
    "prod"    = "westus"
    "staging" = "centralindia"
  }

}



