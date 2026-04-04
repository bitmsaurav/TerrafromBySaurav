# Frequently Asked Questions (FAQ)

## General Questions

### Q: Do I need to modify any code to use this for a new project?
**A:** No! Only update the 6 values in your `environments/{env}/{env}.tfvars` file:
- `azure_subscription_id`
- `project_name`
- `owner`
- `cost_center`

Everything else adapts automatically using the configuration object.

### Q: Can I use this for production workloads?
**A:** Absolutely! The `prod.tfvars` includes:
- High-availability (3 VMs)
- Premium storage with geo-redundancy
- DDoS protection
- Key Vault with RBAC
- Full monitoring with 1-year retention
- Azure Firewall

### Q: What's the cost of running this?
**A:** Depends on environment:
- **Dev**: ~$20-30/month (1 B2s VM, standard storage)
- **Staging**: ~$100-150/month (2 VMs, GRS storage)
- **Prod**: ~$500+/month (3 D2s VMs, premium RAGRS storage)

### Q: Does this support Windows VMs?
**A:** Yes! The compute module uses `azurerm_linux_virtual_machine`, but you can:
1. Create a new module for Windows
2. Or modify the existing module to support both

```hcl
resource "azurerm_windows_virtual_machine" "main" {
  count = var.enabled && var.os_type == "windows" ? var.vm_count : 0
  # ... rest of config
}
```

### Q: How do I add a new resource type?
**A:** Create a new module:
1. Create `modules/resource-type/main.tf`
2. Add `variables.tf` and `outputs.tf`
3. Call module in root `main.tf`
4. Update `infrastructure_config` with enable flag

See [MODULE_GUIDE.md](MODULE_GUIDE.md) for details.

---

## Configuration Questions

### Q: How do I enable Key Vault only for production?
**A:** In `prod.tfvars`:
```hcl
infrastructure_config = {
  prod = {
    enable_key_vault = true
    # ...
  }
}
```

In `dev.tfvars`:
```hcl
infrastructure_config = {
  dev = {
    enable_key_vault = false
    # ...
  }
}
```

### Q: Can I have different VM sizes per environment?
**A:** Yes! Each environment has its own config:
```hcl
# environments/dev/dev.tfvars
vm_size = "Standard_B2s"

# environments/prod/prod.tfvars
vm_size = "Standard_D2s_v3"
```

### Q: How do I deploy to multiple regions?
**A:** Use separate tfvars files or variables:
```bash
# Deploy to eastus
terraform apply -var-file=environments/dev/dev.tfvars \
  -var primary_region=eastus

# Deploy to westus
terraform apply -var-file=environments/dev/dev.tfvars \
  -var primary_region=westus
```

Or configure in tfvars:
```hcl
primary_region   = "eastus"
secondary_region = "westus"
```

### Q: Can I customize NSG rules?
**A:** Yes! Modify `modules/security/main.tf`:
```hcl
resource "azurerm_network_security_rule" "custom" {
  name              = "AllowCustomPort"
  priority          = 300
  direction         = "Inbound"
  access            = "Allow"
  protocol          = "Tcp"
  source_port_range = "*"
  destination_port_range = "8080"
  # ...
}
```

---

## State Management Questions

### Q: Where is my state stored?
**A:** By default, locally in `terraform.tfstate`.

For remote backend (Azure Storage), see [README.md](README.md) Backend Configuration section.

### Q: How do I protect my state?
**A:** For production:
1. Use Azure Storage backend (not local)
2. Enable storage account encryption
3. Enable blob versioning
4. Restrict access with IAM roles

```bash
# Enable versioning
az storage account blob-service-properties update \
  --account-name tfstatestoragedev \
  --enable-change-feed true \
  --enable-versioning true
```

### Q: Can multiple people work on the same state?
**A:** Yes, using Azure Storage backend with state locking:
1. Create shared Azure Storage account
2. Configure `backend.tfbackend` for all users
3. Terraform automatically handles locking

```hcl
# environments/prod/backend.tfbackend
resource_group_name  = "terraform-state-rg"
storage_account_name = "tfstatestoragedev"
container_name       = "prod-tfstate"
key                  = "prod.tfstate"
```

---

## Networking Questions

### Q: How do I connect my on-premises network?
**A:** Add VPN Gateway or ExpressRoute:
```hcl
# Add to modules/network/main.tf
resource "azurerm_vpn_gateway" "main" {
  count = var.enabled && var.enable_vpn ? 1 : 0
  # ...
}
```

Then set in tfvars:
```hcl
enable_vpn = true
```

### Q: Can I use Azure Bastion for secure access?
**A:** Yes! Already included:
```hcl
infrastructure_config = {
  prod = {
    enable_bastion = true
    # ...
  }
}
```

Then:
```bash
# Connect via Bastion
az network bastion rdp --name myproject-prod-eastus-bastion \
  --resource-group myproject-prod-eastus-rg
```

### Q: How do I enable VNet peering?
**A:** In tfvars:
```hcl
allow_peering = true

peering_vnets = {
  "shared-services" = {
    resource_group_name = "shared-services-rg"
    vnet_name           = "shared-services-vnet"
  }
}
```

---

## Security Questions

### Q: How do I store secrets?
**A:** Use Key Vault module (already included):
```hcl
enable_key_vault = true
```

Then:
```bash
# Get secret reference
terraform output security_outputs | jq .key_vault_uri

# Store secret in Key Vault
az keyvault secret set \
  --vault-name myproject-prod-eastus-kv \
  --name my-secret \
  --value "secret-value"
```

### Q: How do I use managed identities?
**A:** Enable in tfvars:
```hcl
enable_managed_identity = true
```

VMs automatically get system-assigned identities. Use them for Azure services access:
```bash
# Assign reader role to VM
az role assignment create \
  --assignee $(terraform output | jq -r .compute_outputs.vm_ids[0]) \
  --role "Reader"
```

### Q: How do I enforce RBAC?
**A:** Configure Key Vault access:
```hcl
# See modules/security/main.tf
# Sets up RBAC via Azure AD
```

Then:
```bash
az keyvault set-policy \
  --name myproject-prod-eastus-kv \
  --object-id <user-object-id> \
  --permissions keys list get
```

### Q: Is data encrypted?
**A:** Yes, by default:
- Storage: Encrypted at rest (SSE)
- Transit: TLS 1.2+ required
- Disks: Managed disk encryption
- Key Vault: Purge protection enabled

---

## Deployment Questions

### Q: How do I deploy without destroying existing resources?
**A:** Use `terraform import`:
```bash
# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/xxx/resourceGroups/rg-name
```

### Q: How do I see what will change?
**A:** Always run plan first:
```bash
terraform plan -var-file=environments/dev/dev.tfvars -out=tfplan

# Review the plan file
terraform show tfplan
```

### Q: Can I apply only specific resources?
**A:** Yes, use `-target`:
```bash
# Apply only VMs
terraform apply -var-file=environments/dev/dev.tfvars \
  -target=module.compute

# Apply specific resource
terraform apply -var-file=environments/dev/dev.tfvars \
  -target=azurerm_resource_group.main
```

### Q: How do I rollback changes?
**A:** Options:
1. **Revert config and reapply**:
   ```bash
   git revert <commit>
   terraform apply -var-file=environments/dev/dev.tfvars
   ```

2. **Use state backup**:
   ```bash
   terraform state pull > backup.tfstate
   # Make changes
   terraform state push backup.tfstate
   ```

---

## Monitoring Questions

### Q: How do I enable monitoring?
**A:** In tfvars:
```hcl
infrastructure_config = {
  prod = {
    enable_monitoring    = true
    enable_log_analytics = true
    enable_app_insights  = true
    retention_in_days    = 365
    # ...
  }
}
```

### Q: Can I view logs?
**A:** If Log Analytics enabled:
```bash
# Query logs
az monitor log-analytics query \
  --workspace /subscriptions/xxx/resourcegroups/rg/providers/microsoft.operationalinsights/workspaces/workspace-name \
  --analytics-query "AzureActivity"
```

---

## Troubleshooting Questions

### Q: Error: "Provider not found"
**A:** Run:
```bash
terraform init -upgrade
```

### Q: Error: "InvalidAuthenticationTokenTenant"
**A:** Set Azure credentials:
```bash
# Via Azure CLI
az login --subscription <subscription-id>

# Or via environment variables
export ARM_SUBSCRIPTION_ID="<subscription-id>"
export ARM_TENANT_ID="<tenant-id>"
export ARM_CLIENT_ID="<client-id>"
export ARM_CLIENT_SECRET="<client-secret>"
```

### Q: Error: "Resource already exists"
**A:** Resource exists outside Terraform. Options:
1. Delete resource manually
2. Import resource into state
3. Use `taint` to force recreation

### Q: SSH access denied
**A:** Verify:
```bash
# Check SSH key exists
ls -la ssh/id_rsa

# Check VM output
terraform output compute_outputs | jq .vm_public_ips

# Try SSH
ssh -i ssh/id_rsa -v azureuser@<vm-ip>
```

---

## Cost Questions

### Q: How do I reduce costs?
**A:** For dev environment:
- Use smaller VM sizes (B2s instead of D2s)
- Disable geo-redundancy (LRS instead of GRS)
- Disable backups
- Use auto-shutdown for non-prod

```hcl
enable_backup     = false
storage_replication_type = "LRS"
vm_size           = "Standard_B1s"
```

### Q: Can I see estimated costs?
**A:** Use Azure pricing calculator:
- Get resources from `terraform output`
- Enter specs in [Azure Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)

---

## CI/CD Questions

### Q: How do I set up CI/CD with GitHub?
**A:** Workflows already included (.github/workflows/):
1. Push to GitHub
2. Create Azure Service Principal:
   ```bash
   az ad sp create-for-rbac --role Contributor \
     --scopes /subscriptions/<subscription-id>
   ```
3. Add secret `AZURE_CREDENTIALS` to GitHub

### Q: Can I customize the CI/CD pipeline?
**A:** Yes! Edit workflow files:
- `terraform-validate.yml` - PR checks
- `terraform-plan.yml` - PR preview
- `terraform-apply.yml` - Auto-deploy on merge

---

## Migration Questions

### Q: Can I migrate existing infrastructure?
**A:** Yes! Use `terraform import`:
```bash
# Find resource ID
az resource list --query "[?name=='my-vm'].id" -o tsv

# Import
terraform import azurerm_linux_virtual_machine.main <resource-id>
```

---

## Support

For more help:
- Check [README.md](README.md) for complete guide
- See [MODULE_GUIDE.md](MODULE_GUIDE.md) for advanced topics
- Review [QUICK_START.md](QUICK_START.md) for step-by-step setup

**Happy terraforming! 🚀**
