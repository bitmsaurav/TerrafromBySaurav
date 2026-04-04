variable "enabled" {
  description = "Enable or disable VM deployment"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Resource group for VMs"
  type        = string
}

variable "location" {
  description = "Azure region for VMs"
  type        = string
}

variable "name" {
  description = "Prefix for VM naming"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to provision"
  type        = number
  default     = 1
  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 100
    error_message = "VM count must be between 1 and 100."
  }
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
}

variable "vm_os_disk_type" {
  description = "OS disk storage type"
  type        = string
}

variable "vm_image" {
  description = "OS image details"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "subnet_id" {
  description = "Subnet ID where VMs are attached"
  type        = string
}

variable "enable_public_ip" {
  description = "Create public IP for each VM"
  type        = bool
  default     = false
}

variable "enable_managed_identity" {
  description = "Enable system-assigned managed identity for VMs"
  type        = bool
  default     = true
}

variable "admin_username" {
  description = "SSH admin username"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used by VMs"
  type        = string
}

variable "tags" {
  description = "Tags applied to all VM resources"
  type        = map(string)
}
