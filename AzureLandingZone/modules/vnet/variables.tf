variable "virtual_networks" {
  description = "Map of virtual networks"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
  }))
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}