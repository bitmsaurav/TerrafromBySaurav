variable "virtual_machines" {
  description = "Map of virtual machines"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    size                = string
    admin_username      = string
    admin_password      = string
  }))
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}