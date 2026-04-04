variable "project_name" {
  description = "Project name used by naming conventions"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, stage, prod."
  }
}

variable "owner" {
  description = "Business owner or team responsible for the resources"
  type        = string
}

variable "cost_center" {
  description = "Cost center code used for tagging and reporting"
  type        = string
}

variable "blue_green_enabled" {
  description = "Enable blue/green deployment naming support"
  type        = bool
  default     = false
}

variable "deployment_slot" {
  description = "Deployment slot name for blue/green strategy"
  type        = string
  default     = "blue"
  validation {
    condition     = can(regex("^(blue|green)$", var.deployment_slot))
    error_message = "Deployment slot must be either 'blue' or 'green'."
  }
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for Linux VM access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "region_configs" {
  description = "Region based infrastructure definitions for hub and spoke deployment"
  type = map(object({
    role      = string
    location  = string
    vnet_cidr = string
    subnets   = map(object({ prefix = string }))
    nsg_rules = map(object({
      priority                = number
      direction               = string
      access                  = string
      protocol                = string
      source_prefixes         = list(string)
      destination_prefixes    = list(string)
      source_port_ranges      = list(string)
      destination_port_ranges = list(string)
      description             = string
    }))
    vm_count        = number
    vm_size         = string
    vm_os_disk_type = string
    vm_image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    default_subnet   = string
    enable_public_ip = bool
  }))
}

variable "environment_settings" {
  description = "Environment-level feature toggles and metadata"
  type = map(object({
    enable_monitoring   = bool
    enable_policy       = bool
    enable_vnet_peering = bool
    approval_required   = bool
    tags                = map(string)
  }))
}

variable "policy_definitions" {
  description = "Custom policy definitions and assignments applied by environment"
  type = map(object({
    display_name = string
    description  = string
    policy_rule  = any
    metadata     = map(string)
    scope        = string
  }))
  default = {}
}

variable "security_role_assignments" {
  description = "Optional IAM role assignments for the landing zone"
  type = map(object({
    principal_id         = string
    role_definition_name = string
    scope                = string
  }))
  default = {}
}
