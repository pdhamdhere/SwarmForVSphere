# Configure the VMware vSphere Provider
provider "vsphere" {
  user                  = "${var.vsphere_user}"
  password              = "${var.vsphere_password}"
  vsphere_server        = "${var.vsphere_server}"
  allow_unverified_ssl  =  "${var.allow_unverified_ssl}"
}


# Create a folder TODO
resource "vsphere_folder" "swarm_cluster" {
    datacenter = "${var.vsphere_datacenter}"
    path = "${var.swarm_cluster_name}"
}

## Create Swarm master
resource "vsphere_virtual_machine" "swarm-master" {
    count   = 1 # "${var.swarm_master_count}"
    name    = "${format("${var.swarm_cluster_name}-master-%02d", count.index)}"
    datacenter = "${var.vsphere_datacenter}"
    resource_pool = "${var.vsphere_resource_pool}"
    folder  = "${vsphere_folder.swarm_cluster.path}"
    vcpu    = 2
    memory = 4096
    skip_customization = true
    network_interface  {
        label = "${var.vsphere_network}"
    }
    disk {
        template = "${var.vsphere_docker_image}"
        datastore   = "${var.vsphere_datastore}"
    }

    provisioner "remote-exec" {
        inline = [
        "docker swarm init --advertise-addr ${self.network_interface.0.ipv4_address}",
        "docker swarm join-token --quiet worker > ${var.swarm_token_dir}/worker.token",
        "docker swarm join-token --quiet manager > ${var.swarm_token_dir}/manager.token"
        ]
        connection {
            host = "${self.network_interface.0.ipv4_address}"
            password = "${var.docker_password}"
            user = "${var.docker_user}"
            }
    }

    provisioner "local-exec" {
        command = "sshpass -p ${var.docker_password} scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null ${var.docker_user}@${self.network_interface.0.ipv4_address}:${var.swarm_token_dir}/worker.token ."
    }

    provisioner "local-exec" {
        command = "sshpass -p ${var.docker_password} scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null ${var.docker_user}@${self.network_interface.0.ipv4_address}:${var.swarm_token_dir}/manager.token ."
    }
}

## Create Swarm nodes

resource "vsphere_virtual_machine" "swarm-worker" {
    count   = "${var.swarm_worker_count}"
    name    = "${format("${var.swarm_cluster_name}-worker-%02d", count.index)}"
    datacenter = "${var.vsphere_datacenter}"
    resource_pool = "${var.vsphere_resource_pool}"
    folder  = "${vsphere_folder.swarm_cluster.path}"
    vcpu    = 2
    memory = 4096
    skip_customization = true
    network_interface  {
        label = "${var.vsphere_network}"
    }
    disk {
        template = "${var.vsphere_docker_image}"
        datastore   = "${var.vsphere_datastore}"
    }

    #provisioner "file" {
    #    source = "worker.token"
    #    destination = "${var.swarm_token_dir}/worker.token"
    #}
    provisioner "local-exec" {
        command = "sshpass -p ${var.docker_password} scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null worker.token ${var.docker_user}@${self.network_interface.0.ipv4_address}:${var.swarm_token_dir}/worker.token"
    }

    provisioner "remote-exec" {
        inline = [
            "docker swarm join --token $(cat ${var.swarm_token_dir}/worker.token) ${vsphere_virtual_machine.swarm-master.network_interface.0.ipv4_address}:2377"
        ]
        connection {
            host = "${self.network_interface.0.ipv4_address}"
            password = "${var.docker_password}"
            user = "${var.docker_user}"
        }        
    }
}
