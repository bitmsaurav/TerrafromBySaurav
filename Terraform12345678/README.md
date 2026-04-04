# Azure Landing Zone Terraform Project

This project provides a highly reusable, enterprise-grade Terraform configuration for deploying a complete Azure Landing Zone across multiple regions with scalable infrastructure and integrated DevSecOps CI/CD pipelines.

## Architecture

The project implements a Hub-Spoke network topology with:
- Centralized logging and monitoring via Azure Monitor and Log Analytics
- Identity and Access Management with RBAC
- Policy enforcement using Azure Policy
- Modular Terraform design for reusability

## Project Structure

```
.
├── modules/                    # Reusable Terraform modules
│   ├── vnet/                  # Virtual Networks and Subnets
│   ├── subnet/                # Subnet management
│   ├── vm/                    # Virtual Machines
│   ├── nsg/                   # Network Security Groups
│   ├── security/              # Azure Policy and Security
│   ├── monitoring/            # Log Analytics and Diagnostics
│   ├── storage/               # Storage Accounts
│   └── loadbalancer/          # Load Balancers
├── docs/                      # Documentation and diagrams
├── backend.tf                 # Remote backend configuration
├── main.tf                    # Root module
├── variables.tf               # Variable definitions
├── providers.tf               # Provider configuration
├── locals.tf                  # Local values
├── terraform.tfvars.example   # Example configuration
├── azure-pipelines.yml        # Azure DevOps CI/CD pipeline
├── README.md                  # This file
└── .terraform/                # Terraform state (generated)
```

## Prerequisites

- Azure subscription
- Azure CLI or Azure PowerShell
- Terraform >= 1.5.0
- Azure DevOps organization (for CI/CD)

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd terraform-azure-landing-zone
   ```

2. **Configure Backend Storage**
   Create a storage account for Terraform state:
   ```bash
   az group create --name tfstate-rg --location "Central India"
   az storage account create --name tfstatestorage --resource-group tfstate-rg --location "Central India" --sku Standard_GRS
   az storage container create --name tfstate --account-name tfstatestorage
   ```

3. **Create Workspace and Configure**
   ```bash
   terraform init -backend=false
   terraform workspace new dev
   terraform workspace select dev
   cp terraform.tfvars.example terraform.tfvars
   ```

   Edit `terraform.tfvars` with your values.

4. **Deploy (Local Testing)**
   ```bash
   terraform plan
   terraform apply
   ```

5. **For Production Deployment**
   Use the Azure DevOps pipeline, which configures the backend automatically.

## Configuration

### Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `resource_prefix` | Prefix for all resources | `myproject` |
| `regions` | List of Azure regions | `["Central India", "East US"]` |
| `vnets` | VNet configurations | See example |
| `vms` | VM configurations | See example |

### Environments

Environments are managed via Terraform workspaces:

```bash
terraform workspace list
terraform workspace select <env>
terraform workspace new <env>
```

The environment name is derived from the current workspace (`terraform.workspace`).

### Scaling Resources

The project supports dynamic creation of resources using `for_each`:

- **50+ VMs**: Configure in `vms` variable
- **50+ VNets/Subnets**: Configure in `vnets` and `subnets`
- **Load Balancers**: Configure in `load_balancers`

Example for 50 VMs:
```hcl
vms = {
  for i in range(50) : "vm-${i}" => {
    name = "vm-${i}"
    # ... other config
  }
}
```

## CI/CD Pipeline

The Azure DevOps pipeline includes:
- **Validate**: Terraform validation with workspace selection
- **Security Scan**: Checkov (SAST), Trivy (SCA)
- **Plan**: Terraform plan in selected workspace
- **Approval**: Manual approval for production
- **Apply**: Terraform apply in selected workspace

### Pipeline Triggers

- Triggered on changes to the repository
- Manual trigger with environment selection (creates/selects workspace)

### Security Integration

- **Checkov**: Terraform security scanning
- **Trivy**: Container and IaC security scanning
- **SonarQube**: Code quality (optional)

## Best Practices

- **DRY Principle**: All configurations are parameterized
- **Least Privilege**: Use managed identities and RBAC
- **Naming Conventions**: Consistent resource naming
- **Tagging**: Cost center, environment, owner tags
- **State Management**: Remote state with locking

## Cost Optimization

Resources are tagged with:
- `CostCenter`: For billing allocation
- `Environment`: For resource lifecycle management
- `Owner`: For accountability

## Blue/Green Deployment

For blue/green deployments:
1. Use separate resource groups or tags
2. Update `environment` variable
3. Deploy parallel environments
4. Switch traffic via DNS or load balancer

## Troubleshooting

### Common Issues

1. **Backend Access**: Ensure storage account permissions
2. **Provider Authentication**: Check Azure credentials
3. **Resource Limits**: Monitor Azure quotas

### Logs

- Terraform logs: `terraform apply -debug`
- Azure DevOps logs: Pipeline run details

## Contributing

1. Follow the modular structure
2. Add tests for new modules
3. Update documentation
4. Use conventional commits

## License

This project is licensed under the MIT License.