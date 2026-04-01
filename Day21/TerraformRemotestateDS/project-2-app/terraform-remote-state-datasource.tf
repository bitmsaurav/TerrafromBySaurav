data "terraform_remote_state" "project1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-storage-rg"
    storage_account_name = "terraformstatemithun201"
    container_name       = "tfstatefile"
    key                  = "network-terraform.tfstate"
  }
}


# # Rsource group name:

# data.terraform_remote_state.project1.outputs.resource_group_name

# #resource group location:

# data.terraform_remote_state.project1.outputs.resource_group_location
# # network interface id
# data.terraform_remote_state.project1.outputs.network_interface_id


