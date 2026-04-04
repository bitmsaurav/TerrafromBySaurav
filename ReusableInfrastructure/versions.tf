terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
    }
  }

  # Backend configuration will be provided via backend config files
  # This allows flexibility for different backends per environment
  # backend "azurerm" {}
}
