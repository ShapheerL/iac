#===============================================================================
# vSphere Modules
#===============================================================================

module "horizon" {
  source                    = "./modules/guest_machines"
  vm_name                   = "horizon"
  vm_template               = "deb-x11-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    os_type                   = "linux"
    cpu                     = 2
    memory                  = 4096
    disk_size               = 16
  }
}

module "stable-diffusion" {
  source                    = "./modules/guest_machines"
  count                     = 0
  vm_name                   = "stable-diffusion"
  vm_template               = "deb-x11-template"
  network_spec = {
    network_id              = "IoT"
  }
  spec = {
    os_type                   = "linux"
    cpu                     = 4
    memory                  = 10240
    disk_size               = 48
  }
}

module "crypto" {
  source                    = "./modules/guest_machines"
  vm_name                   = "crypto"
  vm_template               = "deb-x11-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    os_type                   = "linux"
    cpu                     = 4
    memory                  = 8192
    disk_size               = 48
  }
}

module "mirage" {
  source                    = "./modules/guest_machines"
  vm_name                   = "mirage"
  vm_template               = "deb-x11-template"
  network_spec = {
    network_id              = "Media"
  }
  spec = {
    os_type                   = "linux"
    cpu                     = 4
    memory                  = 8192
    disk_size               = 16
  }
}

module "homeassistant" {
  source                    = "./modules/guest_machines"
  vm_name                   = "valkyrie"
  vm_template               = "deb-x11-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    os_type                   = "linux"
    cpu                     = 2
    memory                  = 2048
    disk_size               = 16
  }
}

module "bloodhound" {
  source                    = "./modules/guest_machines"
  count                     = 0
  vm_name                   = "bloodhound"
  vm_template               = "WinSrv22-template-DE"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    os_type                   = "windows"
    cpu                     = 2
    memory                  = 8192
    disk_size               = 48
  }
}

module "kube-ops" {
  source                    = "./modules/guest_machines"
  count                     = 3
  vm_name                   = "kubes-cp-${count.index + 1}"
  vm_template               = "deb-x11-template"
  network_spec = {
    network_id              = "LAN"
    mac_address             = ["00:50:56:93:8a:b9", "00:50:56:93:35:60", "00:50:56:93:fa:88"][count.index]
  }
  spec = {
    os_type                 = "linux"
    cpu                     = 4
    memory                  = 4096
    disk_size               = 16
    additional_disks = [
      {
        size                = 60
      }
    ]
  }
}

module "traefik" {
  source                    = "./modules/guest_machines"
  count                     = 1
  vm_name                   = "node-01"
  vm_template               = "deb-x11-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    os_type                 = "linux"
    cpu                     = 2
    memory                  = 2048
    disk_size               = 60
  }
}