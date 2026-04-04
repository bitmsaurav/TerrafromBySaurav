variable "vnets" {
  description = "Map of VNets to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    dns_servers         = optional(list(string))
    tags                = optional(map(string))
  }))
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    name                 = string
    resource_group_name  = string
    vnet_key             = string
    address_prefixes     = list(string)
    delegations          = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })))
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}