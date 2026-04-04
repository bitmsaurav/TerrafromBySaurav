###############################################################################
# CORE PROJECT VARIABLES - These define all configurable aspects
###############################################################################

variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project name - used in naming convention"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "primary_region" {
  description = "Primary Azure region"
  type        = string
  default     = "eastus"
  validation {
    condition     = can(regex("^[a-z]+$", var.primary_region))
    error_message = "Region must be a valid Azure region."
  }
}

variable "secondary_region" {
  description = "Secondary Azure region for DR (optional)"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Owner/team email for tagging"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.owner))
    error_message = "Owner must be a valid email address."
  }
}

variable "cost_center" {
  description = "Cost center code for billing tracking"
  type        = string
}

###############################################################################
# INFRASTRUCTURE CONFIGURATION - Central config-driven object
###############################################################################

variable "infrastructure_config" {
  description = "Main infrastructure configuration object supporting multi-environment and multi-region"
  type = map(object({
    # Networking configuration
    enable_network       = bool   # Enable/disable VNet creation
    vpc_cidr             = string # VNet CIDR block
    enable_nat_gateway   = bool   # Enable NAT Gateway for outbound connection
    enable_bastion       = bool   # Enable Azure Bastion for secure access
    enable_ddos_standard = bool   # Enable DDoS Standard protection

    # Compute configuration
    enable_vm             = bool   # Enable/disable VM creation
    vm_count              = number # Number of VMs to create
    vm_size               = string # VM size (Standard_B2s, Standard_D2s_v3, etc)
    vm_os_disk_type       = string # OS disk type (Premium_LRS, Standard_LRS, StandardSSD_LRS)
    vm_image_publisher    = string # VM image publisher
    vm_image_offer        = string # VM image offer
    vm_image_sku          = string # VM image SKU
    vm_image_version      = string # VM image version
    enable_managed_disk   = bool   # Enable managed disks
    additional_data_disks = number # Number of additional data disks

    # Storage configuration
    enable_storage             = bool   # Enable/disable storage account creation
    storage_account_kind       = string # Storage account kind (Storage, StorageV2, BlobStorage)
    storage_account_tier       = string # Performance tier (Standard, Premium)
    storage_replication_type   = string # Replication type (LRS, GRS, RAGRS, ZRS)
    enable_blob_container      = bool   # Enable blob container creation
    blob_container_access_type = string # Private or Blob access
    enable_file_share          = bool   # Enable file share creation
    file_share_quota           = number # File share quota in GB

    # Security configuration
    enable_key_vault        = bool   # Enable/disable Key Vault creation
    enable_acl              = bool   # Enable network ACLs for Key Vault
    key_vault_sku           = string # SKU (standard, premium)
    enable_network_security = bool   # Enable NSG creation and rules
    enable_firewall         = bool   # Enable Azure Firewall

    # Monitoring configuration
    enable_monitoring    = bool # Enable monitoring resources
    enable_log_analytics = bool # Enable Log Analytics Workspace
    enable_app_insights  = bool # Enable Application Insights
    retention_in_days    = number

    # Tagging and metadata
    additional_tags = map(string) # Additional tags to apply to all resources
  }))

  # Example structure provided below
  default = {
    dev = {
      # Networking
      enable_network       = true
      vpc_cidr             = "10.0.0.0/16"
      enable_nat_gateway   = false
      enable_bastion       = false
      enable_ddos_standard = false

      # Compute
      enable_vm             = true
      vm_count              = 1
      vm_size               = "Standard_B2s"
      vm_os_disk_type       = "StandardSSD_LRS"
      vm_image_publisher    = "Canonical"
      vm_image_offer        = "UbuntuServer"
      vm_image_sku          = "18.04-LTS"
      vm_image_version      = "latest"
      enable_managed_disk   = true
      additional_data_disks = 0

      # Storage
      enable_storage             = true
      storage_account_kind       = "StorageV2"
      storage_account_tier       = "Standard"
      storage_replication_type   = "LRS"
      enable_blob_container      = true
      blob_container_access_type = "Private"
      enable_file_share          = false
      file_share_quota           = 100

      # Security
      enable_key_vault        = false
      enable_acl              = false
      key_vault_sku           = "standard"
      enable_network_security = true
      enable_firewall         = false

      # Monitoring
      enable_monitoring    = false
      enable_log_analytics = false
      enable_app_insights  = false
      retention_in_days    = 7

      # Tags
      additional_tags = {
        Tier = "Development"
      }
    }
  }

  validation {
    condition = alltrue([
      for env, config in var.infrastructure_config :
      contains(["Standard_B2s", "Standard_B2ms", "Standard_D2s_v3", "Standard_D4s_v3"], config.vm_size)
    ])
    error_message = "Invalid VM size specified."
  }
}

###############################################################################
# OPTIONAL: Advanced configurations
###############################################################################

variable "enable_advanced_monitoring" {
  description = "Enable advanced monitoring features"
  type        = bool
  default     = false
}

variable "custom_dns_servers" {
  description = "Custom DNS servers for VNet"
  type        = list(string)
  default     = []
}

variable "allow_peering" {
  description = "Allow VNet peering to other VNets"
  type        = bool
  default     = false
}

variable "peering_vnets" {
  description = "VNets to peer with current VNet"
  type = map(object({
    resource_group_name = string
    vnet_name           = string
  }))
  default = {}
}

variable "backup_retention_days" {
  description = "Daily backup retention"
  type        = number
  default     = 7
}

variable "enable_managed_identity" {
  description = "Enable managed identity for resources"
  type        = bool
  default     = true
}
