variable "subnet_info" {
  description = "this is subnet info"
  type        = tuple([string, string])
  default     = ["app-subnet", "10.0.1.0/24"]
}

