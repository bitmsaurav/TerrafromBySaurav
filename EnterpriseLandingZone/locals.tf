locals {
  env_settings = var.environment_settings[var.environment]

  deployment_slot_suffix = var.blue_green_enabled ? "-${var.deployment_slot}" : ""

  common_tags = merge(
    {
      Project        = var.project_name
      Environment    = var.environment
      Owner          = var.owner
      CostCenter     = var.cost_center
      ManagedBy      = "Terraform"
      LandingZone    = "Enterprise"
      DeploymentSlot = var.blue_green_enabled ? var.deployment_slot : "standard"
    },
    local.env_settings.tags
  )

  regions = var.region_configs

  region_resource_groups = {
    for region_key, config in local.regions : region_key => {
      name     = format("%s-%s-rg-%s%s", var.project_name, config.role, region_key, local.deployment_slot_suffix)
      location = config.location
    }
  }

  hub_region_key = try([for region_key, config in local.regions : region_key if config.role == "hub"][0], keys(local.regions)[0])

  spoke_region_keys = [for region_key, config in local.regions : region_key if config.role == "spoke"]

  provisioned_vm_regions = {
    for region_key, config in local.regions : region_key => config if config.vm_count > 0
  }
}

output "_local_deployment_slot_suffix" {
  value = local.deployment_slot_suffix
}
