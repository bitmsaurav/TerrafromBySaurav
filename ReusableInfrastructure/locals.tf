# Common naming convention: <project>-<environment>-<region>-<resource>
locals {
  # Common naming prefix
  name_prefix = "${var.project_name}-${var.environment}-${var.primary_region}"

  # Common tags applied to all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
    CreatedDate = timestamp()
  }

  # Azure resource naming suffix for uniqueness
  random_suffix = substr(md5(var.project_name), 0, 4)

  # Environment-specific variables
  env_config = var.infrastructure_config[var.environment]

  # Compute resource naming
  vm_name = "${local.name_prefix}-vm"

  # Network resource naming
  vnet_name      = "${local.name_prefix}-vnet"
  subnet_name    = "${local.name_prefix}-subnet"
  nsg_name       = "${local.name_prefix}-nsg"
  public_ip_name = "${local.name_prefix}-pip"
  nic_name       = "${local.name_prefix}-nic"


  # Storage resource naming
  storage_account_name = replace("${var.project_name}${var.environment}${var.primary_region}${local.random_suffix}", "-", "")

  # Security resource naming
  keyvault_name = "${local.name_prefix}-kv-${local.random_suffix}"

  # Resource group naming
  resource_group_name = "${local.name_prefix}-rg"
}
