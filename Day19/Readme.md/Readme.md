
**Terraform Remote State Storage & Locking**




## Step-01: Introduction



-   Understand Terraform Backends
-   Understand about Remote State Storage and its advantages
-   This state is stored by default in a local file named  `terraform.tfstate`, but it can also be stored remotely, which works better in a team environment.
-   Create Azure Storage Account to store  `terraform.tfstate`  file and enable backend configurations in terraform settings block

## Step-02: Create Azure Storage Account


### Step-02-01: Create Resource Group



-   Go to Resource Groups -> Add
-   **Resource Group:**  terraform-storage-rg
-   **Region:**  East US
-   Click on  **Review + Create**
-   Click on  **Create**

### Step-02-02: Create Azure Storage Account


-   Go to Storage Accounts -> Add
-   **Resource Group:**  terraform-storage-rg
-   **Storage Account Name:**  terraformstate201 (THIS NAME SHOULD BE UNIQUE ACROSS AZURE CLOUD)
-   **Region:**  East US
-   **Performance:**  Standard
-   **Redundancy:**  Geo-Redundant Storage (GRS)
-   In  `Data Protection`, check the option  `Enable versioning for blobs`
-   REST ALL leave to defaults
-   Click on  **Review + Create**
-   Click on  **Create**

### Step-02-03: Create Container in Azure Storage Account



-   Go to Storage Account ->  `terraformstate201`  -> Containers ->  `+Container`
-   **Name:**  tfstatefiles
-   **Public Access Level:**  Private (no anonymous access)
-   Click on  **Create**

## Step-03: Terraform Backend Configuration



-   **Reference Sub-folder:**  terraform-manifests
-   [Terraform Backend as Azure Storage Account](https://www.terraform.io/docs/language/settings/backends/azurerm.html)
-   Add the below listed Terraform backend block in  `Terrafrom Settings`  block in  `c1-versions.tf`

# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "terraform.tfstate"
  }
  ## References



-   [Terraform Backends](https://www.terraform.io/docs/language/settings/backends/index.html)
-   [Terraform State Storage](https://www.terraform.io/docs/language/state/backends.html)
-   [Terraform State Locking](https://www.terraform.io/docs/language/state/locking.html)
-   [Remote Backends - Enhanced](https://www.terraform.io/docs/language/settings/backends/remote.html)