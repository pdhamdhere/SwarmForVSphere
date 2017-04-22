# Docker Swarm For vSphere using Terraform

0. Install Terraform
1. Clone this repo: `git clone https://github.com/pdhamdhere/SwarmForVSphere.git`
2. Create VM Template (OVA) with following packages and upload to vCenter
   1. Docker 1.13 or higher
   2. Enable root@ssh access
   3. Install open-vm-tools
3. Update configuration in the `variables.tf` file. [Terraform variables](https://www.terraform.io/docs/configuration/variables.html)
4. `terraform apply`
