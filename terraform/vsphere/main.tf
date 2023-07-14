#===============================================================================
# vSphere Modules
#===============================================================================

module "horizon" {
  source                    = "../_modules/vsphere_vm"
  vm_name                   = "horizon"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    #folder                  = data.vsphere_folder.cattles.path
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.docker.id ]
    os_type                 = "linux"
    cpu                     = 2
    memory                  = 5120
    disk_size               = 16
    additional_disks = [
      {
        size                = 25
      }
    ]
  }
}

module "cockpit" {
  source                    = "../_modules/vsphere_vm"
  vm_name                   = "cockpit"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.media.id ]
    os_type                 = "linux"
    cpu                     = 2
    memory                  = 4096
    disk_size               = 48
    additional_disks = [
      {
        size                = null
        datastore_id        = data.vsphere_datastore.media_datastore.id
        attach_disk         = true
      }
    ]
  }
}

module "crypto" {
  source                    = "../_modules/vsphere_vm"
  vm_name                   = "crypto"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.dev.id ]
    os_type                 = "linux"
    cpu                     = 4
    memory                  = 4096
    disk_size               = 16
    additional_disks = [
      {
        size                = 25
      }
    ]
  }
}

module "mirage" {
  source                    = "../_modules/vsphere_vm"
  vm_name                   = "mirage"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "Media"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.media.id, vsphere_tag.docker.id ]
    os_type                 = "linux"
    cpu                     = 4
    memory                  = 8192
    disk_size               = 16
    additional_disks = [
      {
        size                = 25
      }
    ]
  }
}

module "homeassistant" {
  source                    = "../_modules/vsphere_vm"
  vm_name                   = "valkyrie"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.docker.id ]
    os_type                 = "linux"
    cpu                     = 2
    memory                  = 2048
    disk_size               = 16
    additional_disks = [ 
      {
        size                = 25
      } 
    ]
  }
}

module "bloodhound" {
  source                    = "../_modules/vsphere_vm"
  count                     = 0
  vm_name                   = "bloodhound"
  vm_template               = "WinSrv22-template-DE"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.windows.id ]
    os_type                 = "windows"
    cpu                     = 2
    memory                  = 8192
    disk_size               = 48
  }
}

module "kube-ops" {
  source                    = "../_modules/vsphere_vm"
  count                     = 3
  vm_name                   = "kubes-cp-${count.index + 1}"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "LAN"
    mac_address             = ["00:50:56:93:8a:b9", "00:50:56:93:35:60", "00:50:56:93:fa:88"][count.index]
    static_mac_addr         = true
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.kubernetes.id ]
    os_type                 = "linux"
    enable_hv               = true
    cpu                     = 4
    memory                  = 10240
    disk_size               = 16
    additional_disks = [
      {
        size                = 25
      }
    ]
  }
}

module "traefik" {
  source                    = "../_modules/vsphere_vm"
  count                     = 1
  vm_name                   = "node-01"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.docker.id ]
    os_type                 = "linux"
    cpu                     = 2
    memory                  = 2048
    disk_size               = 60
  }
}