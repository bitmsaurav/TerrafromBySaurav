resource "azurerm_resource_group" "myrg" {
  name     = "myrg1"
  location = "East US"
  tags = {
    "tag1" ="my-rg-mithun"
  }
}

