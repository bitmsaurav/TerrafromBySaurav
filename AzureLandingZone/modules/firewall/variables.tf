variable "firewalls" {
  description = "Map of firewalls"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    public_ip_id        = string
  }))
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}