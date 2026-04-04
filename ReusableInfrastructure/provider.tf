provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = true
      skip_shutdown_and_force_delete = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }

  # Azure subscription and authentication via environment variables or Azure CLI
  # Set via: azure_subscription_id variable or ARM_SUBSCRIPTION_ID env var
}
