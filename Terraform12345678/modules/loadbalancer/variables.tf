variable "public_ips" {
  description = "Map of public IPs to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    sku                 = optional(string, "Standard")
    tags                = optional(map(string))
  }))
}

variable "load_balancers" {
  description = "Map of load balancers to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    frontend_ip_configuration = object({
      name                 = string
      public_ip_address_id = string
    })
    tags = optional(map(string))
  }))
}

variable "backend_address_pools" {
  description = "Map of backend address pools"
  type = map(object({
    lb_key = string
    name   = string
  }))
}

variable "probes" {
  description = "Map of health probes"
  type = map(object({
    lb_key = string
    name   = string
    port   = number
  }))
}

variable "rules" {
  description = "Map of LB rules"
  type = map(object({
    lb_key                        = string
    name                          = string
    protocol                      = string
    frontend_port                 = number
    backend_port                  = number
    frontend_ip_configuration_name = string
    backend_address_pool_key      = string
    probe_key                     = string
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}