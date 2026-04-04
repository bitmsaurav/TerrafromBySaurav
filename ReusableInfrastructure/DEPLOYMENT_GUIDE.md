# Production Deployment Guide

Enterprise-grade checklist for deploying to production.

## Pre-Deployment Checklist

### 1. Planning Phase

- [ ] Collect requirements from stakeholders
- [ ] Define resource specifications (VM size, storage capacity, etc.)
- [ ] Document compliance & security requirements
- [ ] Identify cost budget & optimization opportunities
- [ ] Plan for disaster recovery & backup strategy
- [ ] Define monitoring & alerting requirements

### 2. Infrastructure Review

- [ ] Review `prod.tfvars` configuration
- [ ] Verify resource sizing matches requirements
- [ ] Confirm networking design (CIDR blocks, NSG rules)
- [ ] Validate security settings (Key Vault, firewall, DDoS)
- [ ] Check tagging strategy for cost tracking
- [ ] Confirm backup and retention policies

### 3. Access & Permissions

- [ ] Azure subscription confirmed
- [ ] Azure CLI authenticated
- [ ] Azure credentials configured
- [ ] Service principal created (for CI/CD)
- [ ] RBAC roles assigned appropriately
- [ ] SSH keys generated (if using Linux VMs)

### 4. Backend Setup

- [ ] Create Azure Storage account for state
- [ ] Enable versioning on storage account
- [ ] Configure backend.tfbackend
- [ ] Test backend connectivity
- [ ] Backup current state

---

## Step-by-Step Deployment

### Step 1: Initialize Infrastructure

```bash
cd terraform-infra

# Create SSH key
make ssh-key

# Generate SSH key if not present
mkdir -p ssh
ssh-keygen -t rsa -b 4096 -f ssh/id_rsa -N "" || echo "Key exists"
```

### Step 2: Validate Configuration

```bash
# Format check
make fmt

# Syntax validation
make validate

# Plan without applying
make plan ENVIRONMENT=prod
```

**Review the plan output carefully:**
- ✓ Correct resource count?
- ✓ Correct VM sizes, storage tiers?
- ✓ All security features enabled?
- ✓ Tagging correct?

### Step 3: Terraform State Setup

```bash
# Initialize with production backend
make init ENVIRONMENT=prod
```

### Step 4: Pre-Apply Backup

```bash
# Backup existing state (if any)
make state-pull ENVIRONMENT=prod
# Saves to: current-state-backup.json
```

### Step 5: Apply Configuration

```bash
# First, show what will happen (safety measure)
make plan ENVIRONMENT=prod

# Then apply
make apply ENVIRONMENT=prod
```

**Wait for completion** - Usually 5-10 minutes

Expected output:
```
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:
deployment_region = "eastus"
...
```

### Step 6: Verify Deployment

```bash
# Get all outputs
make output ENVIRONMENT=prod

# Verify in Azure Portal
az resource list --resource-group myproject-prod-eastus-rg
```

---

## Post-Deployment Validation

### 1. Network Verification

```bash
# Get VNet ID from outputs
VNET_ID=$(make output ENVIRONMENT=prod | grep vnet_id | awk '{print $NF}')

# Verify VNet
az network vnet show --ids $VNET_ID

# Check subnets
az network vnet subnet list --resource-group myproject-prod-eastus-rg --vnet-name myproject-prod-eastus-vnet
```

### 2. Compute Verification

```bash
# List VMs
az vm list --resource-group myproject-prod-eastus-rg -o table

# Get public IP
az vm show -d --resource-group myproject-prod-eastus-rg --name myproject-prod-eastus-vm-1

# SSH into VM
VM_IP=$(az vm show -d --resource-group myproject-prod-eastus-rg --name myproject-prod-eastus-vm-1 --query publicIps -o tsv)
ssh -i ssh/id_rsa azureuser@$VM_IP
```

### 3. Storage Verification

```bash
# List storage accounts
az storage account list --resource-group myproject-prod-eastus-rg

# Verify blob container
STORAGE=$(make output ENVIRONMENT=prod | grep storage_account_name | awk '{print $NF}')
az storage container list --account-name $STORAGE --account-key <access-key>
```

### 4. Security Verification

```bash
# Verify Key Vault
az keyvault list --resource-group myproject-prod-eastus-rg

# Check secrets
KV_NAME=$(make output ENVIRONMENT=prod | grep key_vault_name | awk '{print $NF}')
az keyvault secret list --vault-name $KV_NAME
```

### 5. Monitoring Verification

```bash
# Check if monitoring is enabled
az monitor metrics list \
  --resource /subscriptions/<sub-id>/resourceGroups/myproject-prod-eastus-rg \
  --metric-names Percentage\ CPU
```

---

## Security Hardening

### 1. Access Management

```bash
# Create Azure AD group for team
az ad group create --display-name "Terraform-Prod-Admins"

# Assign roles
az role assignment create \
  --assignee-object-id <group-object-id> \
  --role "Contributor" \
  --scope /subscriptions/<subscription-id>/resourceGroups/myproject-prod-eastus-rg
```

### 2. Key Management

```bash
# Store credentials in Key Vault
KV_NAME=$(make output ENVIRONMENT=prod | grep key_vault_name | awk '{print $NF}')

# Add SSH private key
az keyvault secret set \
  --vault-name $KV_NAME \
  --name ssh-private-key \
  --file ssh/id_rsa

# Add database credentials
az keyvault secret set \
  --vault-name $KV_NAME \
  --name db-password \
  --value "SecurePassword123!"
```

### 3. Network Security

```bash
# Custom NSG rules as needed
az network nsg rule create \
  --resource-group myproject-prod-eastus-rg \
  --nsg-name myproject-prod-eastus-nsg \
  --name AllowWebTraffic \
  --priority 300 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --source-address-prefixes "*" \
  --destination-port-ranges 80 443
```

---

## Monitoring & Alerting

### 1. Enable Monitoring

If not already enabled in tfvars:
```hcl
enable_monitoring    = true
enable_log_analytics = true
enable_app_insights  = true
retention_in_days    = 365
```

Then:
```bash
make plan ENVIRONMENT=prod
make apply ENVIRONMENT=prod
```

### 2. Create Alerts

```bash
# CPU usage alert
az monitor metrics alert create \
  --name "HighCPUAlert" \
  --resource-group myproject-prod-eastus-rg \
  --scopes /subscriptions/<sub-id>/resourceGroups/myproject-prod-eastus-rg \
  --condition "avg Percentage CPU > 80" \
  --action email-action \
  --email-receiver admin --email-address ops@company.com
```

### 3. View Logs

```bash
# Query application logs
az monitor log-analytics query \
  --workspace /subscriptions/<sub-id>/resourcegroups/myproject-prod-eastus-rg/providers/microsoft.operationalinsights/workspaces/<workspace-name> \
  --analytics-query "AzureMetrics | where TimeGenerated > ago(1h)"
```

---

## Backup & Disaster Recovery

### 1. State File Backup

```bash
# Daily backup to secure location
az storage blob upload \
  --account-name backup-storage \
  --container-name terraform-state \
  --name "prod-tfstate-$(date +%Y%m%d).json" \
  --file current-state-backup.json
```

### 2. VM Snapshots

```bash
# Create snapshot of OS disk
az snapshot create \
  --resource-group myproject-prod-eastus-rg \
  --name myproject-prod-vm-snapshot \
  --source /subscriptions/<sub-id>/resourceGroups/myproject-prod-eastus-rg/providers/Microsoft.Compute/disks/myproject-prod-eastus-vm-1_OsDisk
```

### 3. Storage Backup

```bash
# Blob versioning already enabled
# Snapshots already configured

# Test restore (low-impact)
az storage blob restore \
  --account-name <storage-account> \
  --time-to-restore $(date -u +"%Y-%m-%dT%H:%M:%SZ")
```

---

## Documentation

### 1. Create Deployment Record

```bash
# Document deployment details
cat > deployment-record-prod-2024.md << EOF
# Production Deployment Record

**Date:** $(date)
**Environment:** Production
**Region:** eastus
**Deployed By:** $(whoami)

## Resources
- Resource Group: $(make output ENVIRONMENT=prod | grep resource_group_name)
- VNets: $(make output ENVIRONMENT=prod | grep vnet_name)
- VMs: $(make output ENVIRONMENT=prod | grep vm_names)

## Outputs
$(make output ENVIRONMENT=prod > outputs.json 2>&1)

## Status
✓ Deployment successful
✓ All resources verified
✓ Monitoring enabled
✓ Backups configured

EOF
```

### 2. Create Runbook

```bash
# Quick reference guide for ops team
cat > runbook-prod.md << EOF
# Production Runbook

## Accessing Resources

### Via SSH
\`\`\`
VM_IP=$(az vm show -d -g myproject-prod-eastus-rg -n myproject-prod-eastus-vm-1 --query publicIps -o tsv)
ssh -i ssh/id_rsa azureuser@\$VM_IP
\`\`\`

### Via Bastion
\`\`\`
az network bastion rdp --name myproject-prod-eastus-bastion
\`\`\`

## Common Tasks

### Restart VM
\`\`\`
az vm restart -g myproject-prod-eastus-rg -n myproject-prod-eastus-vm-1
\`\`\`

### Check Logs
\`\`\`
az monitor log-analytics query --workspace <workspace-id> --analytics-query "AzureActivity"
\`\`\`

### Backups
\`\`\`
az backup job list -g myproject-prod-eastus-rg
\`\`\`

EOF
```

---

## Post-Deployment Optimization

### 1. Cost Optimization

```bash
# Review resource utilization
az monitor metrics list \
  --resource /subscriptions/<sub-id>/resourceGroups/myproject-prod-eastus-rg/providers/Microsoft.Compute/virtualMachines/myproject-prod-eastus-vm-1 \
  --metric-names "Percentage CPU" \
  --start-time 2024-01-01T00:00:00Z \
  --interval PT1H
```

### 2. Performance Tuning

```bash
# Adjust VM size if needed
make plan ENVIRONMENT=prod -var 'infrastructure_config.prod.vm_size=Standard_D4s_v3'

# Apply if appropriate
make apply ENVIRONMENT=prod
```

### 3. Auto-Scaling (Future)

```bash
# Can be added to modules/compute/
# Create VMSS instead of individual VMs
# Implement application-level load balancing
```

---

## Rollback Procedure

### If Something Goes Wrong

```bash
# Option 1: Revert to previous state backup
terraform state push previous-state-backup.json

# Option 2: Destroy and redeploy
make destroy ENVIRONMENT=prod

# Option 3: Use version control
git revert <commit-hash>
make apply ENVIRONMENT=prod
```

---

## Sign-Off

Before declaring deployment complete:

- [ ] All resources deployed
- [ ] Security hardening complete
- [ ] Monitoring & alerting configured
- [ ] Backups & DR tested
- [ ] Documentation completed
- [ ] Team trained on runbook
- [ ] Stakeholders notified

---

## Support & Escalation

| Issue | Contact | Escalate After |
|-------|---------|-----------------|
| Terraform errors | Platform Team | 30 min |
| Azure API errors | Azure Support | 1 hour |
| Performance issues | DevOps Team | 2 hours |
| Security concerns | Security Team | Immediately |

---

**Deployment Complete! 🚀**

Next: [Ongoing Operations & Maintenance](MAINTENANCE.md)
