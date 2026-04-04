variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "primary_region" {
  description = "Primary region"
  type        = string
  default     = "East US"
}

variable "dr_region" {
  description = "DR region"
  type        = string
  default     = "West US"
}

variable "backend_resource_group_name" {
  description = "Backend Resource Group Name"
  type        = string
}

variable "backend_storage_account_name" {
  description = "Backend Storage Account Name"
  type        = string
}

variable "backend_container_name" {
  description = "Backend Container Name"
  type        = string
  default     = "tfstate"
}

variable "backend_key" {
  description = "Backend Key"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}