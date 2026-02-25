#input veriables

#Business unit name
variable "bussiness_unit" {
  description = "this is bussiness unit name"
  type        = string
  default     = "IT"
}
# Environment name
variable "environment_name" {
  description = "this is env name"
  type        = string
  default     = "DEV"
}
# Resourse group name
variable "resourse_group_name" {
  description = "this is resourse group name"
  type        = string
  default     = "myrg"

}
# resourse group location
variable "resourse_group_location" {
  description = "this the resouser group location"
  type        = string
  default     = "eastus"
  validation {
    # condition     = var.resourse_group_location == "eastus" || var.resourse_group_location == "centerindia"
    #condition = contains(["eastus","centerindia"],var.resourse_group_location)
    condition = can(regex("india$",var.resourse_group_location))
    error_message = "we only allow resouser group to be created in westindia or centerindia locations"
  }

}