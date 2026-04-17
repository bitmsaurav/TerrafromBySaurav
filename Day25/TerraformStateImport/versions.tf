terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }


}

provider "azurerm" {
  features {}
  subscription_id = "38b4536a-4483-490a-a8ab-5f0bd64454d2"
}

