variable "load_balancers" {
  description = "Map of load balancers"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    frontend_name       = string
    subnet_id           = string
  }))
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}