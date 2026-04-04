###############################################################################
# OUTPUTS - Expose important values from deployed resources
###############################################################################

output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.main.id
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.main.name
}

output "deployment_environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "deployment_region" {
  description = "Primary deployment region"
  value       = var.primary_region
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

# Network Outputs
output "network_outputs" {
  description = "Network module outputs"
  value = {
    vnet_id           = try(module.network.vnet_id, null)
    vnet_name         = try(module.network.vnet_name, null)
    subnet_id         = try(module.network.subnet_id_primary, null)
    subnet_name       = try(module.network.subnet_name_primary, null)
    nsg_id            = try(module.network.nsg_id, null)
    nat_gateway_id    = try(module.network.nat_gateway_id, null)
    bastion_host_id   = try(module.network.bastion_host_id, null)
    public_ip_address = try(module.network.public_ip_address, null)
  }
  sensitive = false
}

# Compute Outputs
output "compute_outputs" {
  description = "Compute module outputs"
  value = {
    vm_ids                = try(module.compute.vm_ids, [])
    vm_names              = try(module.compute.vm_names, [])
    vm_private_ips        = try(module.compute.vm_private_ips, [])
    vm_public_ips         = try(module.compute.vm_public_ips, [])
    network_interface_ids = try(module.compute.network_interface_ids, [])
  }
  sensitive = false
}

# Storage Outputs
output "storage_outputs" {
  description = "Storage module outputs"
  value = {
    storage_account_id   = try(module.storage.storage_account_id, null)
    storage_account_name = try(module.storage.storage_account_name, null)
    blob_container_id    = try(module.storage.blob_container_id, null)
    file_share_id        = try(module.storage.file_share_id, null)
    storage_access_key   = try(module.storage.storage_access_key, null)
  }
  sensitive = true
}

# Security Outputs
output "security_outputs" {
  description = "Security module outputs"
  value = {
    key_vault_id   = try(module.security.key_vault_id, null)
    key_vault_name = try(module.security.key_vault_name, null)
    key_vault_uri  = try(module.security.key_vault_uri, null)
  }
  sensitive = false
}

# Summary Output
output "deployment_summary" {
  description = "Deployment summary"
  value = {
    name        = local.name_prefix
    tags        = local.common_tags
    config_file = "${var.environment}.tfvars"
  }
}
