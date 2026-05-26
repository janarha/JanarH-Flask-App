terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
  required_version = ">= 1.3.0"
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "web_01" {
  name        = "web-01"
  target_node = var.proxmox_node
  clone       = var.ubuntu_template
  os_type     = "cloud-init"
  cores       = 2
  memory      = 2048
  disk {
    slot    = 0
    size    = "20G"
    type    = "scsi"
    storage = var.storage_pool
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0  = "ip=${var.web01_ip}/24,gw=${var.gateway}"
  ciuser     = var.vm_user
  sshkeys    = var.ssh_public_key
  cipassword = var.vm_password
  tags       = "web,flask,docker"
}

resource "proxmox_vm_qemu" "db_01" {
  name        = "db-01"
  target_node = var.proxmox_node
  clone       = var.ubuntu_template
  os_type     = "cloud-init"
  cores       = 2
  memory      = 2048
  disk {
    slot    = 0
    size    = "30G"
    type    = "scsi"
    storage = var.storage_pool
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0  = "ip=${var.db01_ip}/24,gw=${var.gateway}"
  ciuser     = var.vm_user
  sshkeys    = var.ssh_public_key
  cipassword = var.vm_password
  tags       = "db,postgresql"
}

resource "proxmox_vm_qemu" "monitor_01" {
  name        = "monitor-01"
  target_node = var.proxmox_node
  clone       = var.ubuntu_template
  os_type     = "cloud-init"
  cores       = 2
  memory      = 2048
  disk {
    slot    = 0
    size    = "20G"
    type    = "scsi"
    storage = var.storage_pool
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0  = "ip=${var.monitor01_ip}/24,gw=${var.gateway}"
  ciuser     = var.vm_user
  sshkeys    = var.ssh_public_key
  cipassword = var.vm_password
  tags       = "monitoring"
}
