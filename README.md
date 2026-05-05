# Terraform Local Docker Lab
This project automates a local Nginx deployment on an M1 Mac using Colima.

## 🛠️ Tech Stack
- **Infrastructure:** Terraform (using null_resource)
- **Runtime:** Docker via Colima (aarch64)
- **OS:** macOS (M1/ARM)

## 🚀 How to Run
1. Ensure Colima is started: `colima start`
2. Initialize: `terraform init`
3. Deploy: `terraform apply -auto-approve`
