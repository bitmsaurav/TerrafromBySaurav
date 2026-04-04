subscription_id = "your-subscription-id"
backend_resource_group_name = "rg-backend"
backend_storage_account_name = "stbackend123"
backend_container_name = "tfstate"
backend_key = "dev.terraform.tfstate"

resource_groups = {
  primary = {
    name     = "rg-dev-primary"
    location = "East US"
  }
  dr = {
    name     = "rg-dev-dr"
    location = "West US"
  }
}

virtual_networks = {
  primary = {
    name                = "vnet-dev-primary"
    location            = "East US"
    resource_group_name = "rg-dev-primary"
    address_space       = ["10.0.0.0/16"]
  }
}

tags = {
  owner       = "team"
  cost-center = "dev"
}