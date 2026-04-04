variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    size                = string
    os_type             = string
    admin_username      = string
    admin_password      = string
    subnet_id           = string
    public_ip_id        = optional(string)
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    tags = optional(map(string))
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}