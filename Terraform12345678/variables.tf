variable "resource_prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "regions" {
  description = "List of regions to deploy to"
  type        = list(string)
}

variable "deployment_slot" {
  description = "Deployment slot for blue/green deployments"
  type        = string
  default     = ""
}

variable "vnets" {
  description = "VNets configuration"
  type        = any
}

variable "subnets" {
  description = "Subnets configuration"
  type        = any
}

variable "nsgs" {
  description = "NSGs configuration"
  type        = any
}

variable "subnet_nsg_associations" {
  description = "Subnet-NSG associations"
  type        = any
}

variable "vms" {
  description = "VMs configuration"
  type        = any
}

variable "log_analytics_workspaces" {
  description = "Log Analytics workspaces"
  type        = any
}

variable "diagnostic_settings" {
  description = "Diagnostic settings"
  type        = any
}

variable "policy_definitions" {
  description = "Policy definitions"
  type        = any
}

variable "policy_assignments" {
  description = "Policy assignments"
  type        = any
}

variable "storage_accounts" {
  description = "Storage accounts"
  type        = any
}

variable "storage_containers" {
  description = "Storage containers"
  type        = any
}

variable "public_ips" {
  description = "Public IPs"
  type        = any
}

variable "load_balancers" {
  description = "Load balancers"
  type        = any
}

variable "backend_address_pools" {
  description = "Backend address pools"
  type        = any
}

variable "probes" {
  description = "Health probes"
  type        = any
}

variable "rules" {
  description = "LB rules"
  type        = any
}