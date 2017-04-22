## Prerequisites
# 1. terraform
# 2. sshpass

## Bring Your Own OVA
# 1. Docker 1.13+
# 2. Enable root@ssh
# 3. Install openvm-tools

## TODO
# 1. Set Hostname in guest
# 2. Multi-Master: Serialize and join existing master?
# 3. Multi-worker: Serialize. Which master to join?

## vSphere Auth

variable "vsphere_server" {
    description = "vCenter IP or FQDN"
    #default = "10.160.61.222"
}
variable "vsphere_user" {
    description = "vCenter User Name"
    #default = "administrator@vsphere.local"
}
variable "vsphere_password" {
    description = "vCenter Password"
    #default = "Admin!23"
}
variable "allow_unverified_ssl" {
    default = true
}

## vSphere Vars

variable "vsphere_datacenter" {
    description = "Datacenter"
    #default = "vcqaDC"
}
variable "vsphere_resource_pool" {
    description = "Cluster/ Resource Pool"
    #default = "vsan-1"
}
variable "vsphere_datastore" {
    description = "Datastore"
    #default = "sharedVmfs-0"
}
variable "vsphere_network" {
    description = "Network Name"
    default = "VM Network"
}

## Docker Template VM 

variable "vsphere_docker_image" {
  description = "OVA template"
  # default = "swarm1"
  # "KubernetesAnywhereTemplatePhotonOS.ova"
}

variable "docker_user" {
  description = "User to use to connect the machine using SSH."
  default = "root"
}

variable "docker_password" {
  description = "User to use to connect the machine using SSH."
  default = "vmware"
}


## Swarm setup

variable "swarm_token_dir" {
  description = "Path (on the remote machine) which contains the generated swarm tokens"
  default = "/home"
}

variable "swarm_cluster_name" {
  description = "Name of the cluster, used also for networking"
  default = "swarm"
}

variable "swarm_master_count" {
  description = "Number of master nodes."
  default = "1"
}

variable "swarm_worker_count" {
  description = "Number of agents to deploy"
  default = "2"
}