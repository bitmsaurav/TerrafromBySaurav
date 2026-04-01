# 1.Busssiness unit name
variable "bussiness_unit" {
  description = "bussiness unit name"
  type        = string
  default     = "hr"
}

# 2.environment name
variable "environment_name" {
  description = "environment name"
  type        = string
  default     = "dev"
}
# 3. virtual machine name
variable "virtual_machine_name" {
  description = "this is virtual machine name"
  type        = string

}