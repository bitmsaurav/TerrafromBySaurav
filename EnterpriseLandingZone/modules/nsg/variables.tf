variable "enabled" {
  description = "Enable or disable the NSG module"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Resource group containing the NSG"
  type        = string
}

variable "location" {
  description = "Azure region for the NSG"
  type        = string
}

variable "name" {
  description = "NSG name"
  type        = string
}

variable "rules" {
  description = "NSG rule definitions"
  type = map(object({
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
  default = {}
}

variable "tags" {
  description = "Tags applied to the NSG"
  type        = map(string)
}
