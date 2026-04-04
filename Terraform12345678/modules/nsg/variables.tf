variable "nsgs" {
  description = "Map of NSGs to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rules      = list(object({
      name                                       = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
    }))
    tags = optional(map(string))
  }))
}

variable "subnet_nsg_associations" {
  description = "Map of subnet-NSG associations"
  type = map(object({
    subnet_id = string
    nsg_key   = string
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}