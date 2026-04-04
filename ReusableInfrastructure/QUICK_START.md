# Quick Start Guide - Deploy in 5 Minutes

Complete, step-by-step guide to deploy your first infrastructure.

## Prerequisites

- Terraform 1.3.0 or higher
- Azure CLI or Azure credentials configured
- Azure subscription ID

## Step 1: Clone Repository

```bash
git clone <repo-url> my-terraform-project
cd my-terraform-project
```

## Step 2: Configure Your Project

Open `environments/dev/dev.tfvars` and update ONLY these 6 values:

```hcl
###############################################################################
# CUSTOMIZE THESE VALUES FOR YOUR PROJECT
###############################################################################

# Your Azure Subscription ID (get from: az account show --query id)
azure_subscription_id = "12345678-1234-1234-1234-123456789012"

# Your project name (lowercase, hyphens allowed)
project_name = "myproject"

# Keep as dev for first deployment
environment = "dev"

# Choose nearest Azure region (eastus, westus, uksouth, etc.)
primary_region = "eastus"

# Your team's email
owner = "devteam@company.com"

# Your cost center code
cost_center = "PROJ-001"

# Keep rest of the file as-is, resources will be minimal for dev
```

## Step 3: Create SSH Key (for VM Access)

```bash
# Create ssh directory
mkdir -p ssh

# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ssh/id_rsa -N ""

# Verify key was created
ls -la ssh/
```

## Step 4: Initialize Terraform

```bash
# Initialize Terraform (downloads providers and modules)
terraform init
```

You should see:
```
Terraform has been successfully configured!
```

## Step 5: Review What Will Be Deployed

```bash
# Preview all resources
terraform plan -var-file=environments/dev/dev.tfvars
```

You'll see something like:
```
Plan: 12 to add, 0 to change, 0 to destroy.
```

This is a **dry run** showing what Terraform will create.

## Step 6: Deploy Infrastructure

```bash
# Deploy all resources
terraform apply -var-file=environments/dev/dev.tfvars
```

When prompted: `Do you want to perform these actions?`

Type: `yes` and press Enter

**Wait 3-5 minutes for deployment to complete...**

✅ Success! You'll see:
```
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.
```

## Step 7: Retrieve Outputs

After deployment, get connection details:

```bash
# Get all outputs
terraform output

# Get only compute details (IP addresses, VM names)
terraform output compute_outputs

# Get network details
terraform output network_outputs

# Get everything as JSON
terraform output -json > deployment-info.json
```

Example output:
```
deployment_environment = "dev"
deployment_region = "eastus"
network_outputs = {
  "nsg_id" = "/subscriptions/..."
  "public_ip_address" = "52.123.45.67"
  "subnet_id" = "/subscriptions/..."
  "vnet_id" = "/subscriptions/..."
  "vnet_name" = "myproject-dev-eastus-vnet"
}
```

## Connect to Your VM

```bash
# Get VM IP from outputs
VM_IP=$(terraform output -json compute_outputs | jq -r '.[0]')

# SSH into VM
ssh -i ssh/id_rsa azureuser@$VM_IP
```

## Step 8: Cleanup (Optional)

When done testing, remove all resources to save costs:

```bash
# Remove everything
terraform destroy -var-file=environments/dev/dev.tfvars
```

Type: `yes` when prompted

---

## Next Steps

✅ Deploy to staging:
```bash
terraform apply -var-file=environments/staging/staging.tfvars
```

✅ Deploy to production:
```bash
terraform apply -var-file=environments/prod/prod.tfvars
```

✅ Customize configuration:
- Enable Key Vault
- Add more VMs
- Enable monitoring
- Change VM size

See [README.md](README.md) for complete documentation.

---

## Troubleshooting

**Error: "Provider not found"**
```bash
terraform init -upgrade
```

**Error: "Invalid subscription ID"**
```bash
# Get your subscription ID
az account show --query id

# Update dev.tfvars with the ID
```

**Error: "SSH key not found"**
```bash
# Generate SSH key
mkdir -p ssh
ssh-keygen -t rsa -b 4096 -f ssh/id_rsa -N ""
```

**Error: "Resource already exists"**
```bash
# List existing resources
terraform state list

# View current state
terraform state show azurerm_resource_group.main
```

---

**Deployed! 🎉 Your infrastructure is ready to use.**
