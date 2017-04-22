# Docker Swarm For vSphere using Terraform

0. Install Terraform
1. Clone this repo: `git clone https://github.com/pdhamdhere/SwarmForVSphere.git`
2. Create VM Template (OVA) with following packages and upload to vCenter
   a. Docker 1.13 or higher
   b. Enable root@ssh access
   c. Install open-vm-tools
3. Update configuration in the `variables.tf` file. [Terraform variables](https://www.terraform.io/docs/configuration/variables.html)
4. `terraform apply`
