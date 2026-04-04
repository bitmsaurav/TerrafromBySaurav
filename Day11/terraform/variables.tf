variable "rg_config" {
  type = object({
    name     = string
    location = string
  })
  default = {
    name     = "my-simapale-rg"
    location = "eastus"
  }

}


