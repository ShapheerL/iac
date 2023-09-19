#===============================================================================
# vSphere Modules
#===============================================================================

module "cockpit" {
  source                    = "../_modules/vsphere_vm"
  vm_name                   = "cockpit"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.media.id ]
    folder                  = vsphere_folder.media.path
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

module "mirage" {
  source                    = "../_modules/vsphere_vm"
  vm_name                   = "mirage"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "Media"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.media.id, vsphere_tag.docker.id ]
    folder                  = vsphere_folder.media.path
    cpu                     = 2
    memory                  = 2048
    memory_reservation      = true
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
    folder                  = vsphere_folder.personal_linux.path
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

module "gaming-vm-01" {
  source                    = "../_modules/vsphere_vm"
  count                     = 0
  vm_name                   = "gaming-vm-01"
  vm_template               = "WSrv22-DE-Temp"
  network_spec = {
    network_id              = "IoT"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.windows.id ]
    folder                  = vsphere_folder.gaming_windows.path
    cpu                     = 4
    memory                  = 8192
    disk_size               = 48
    additional_disks = [
      {
        size                = 100
      }
    ]
  }
}

module "kube-ops" {
  source                    = "../_modules/vsphere_vm"
  count                     = 3
  vm_name                   = "kubes-cp-${count.index + 1}"
  vm_template               = "k3s-deb12"
  network_spec = {
    network_id              = "LAN"
    mac_address             = ["00:50:56:93:8a:b9", "00:50:56:93:35:60", "00:50:56:93:fa:88"][count.index]
    static_mac_addr         = true
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.kubernetes.id ]
    folder                  = vsphere_folder.kubernetes.path
    enable_hv               = true
    cpu                     = 4
    memory                  = 1024 * 24
    disk_size               = 32
    additional_disks = [
      {
        size                = 75
      }
    ]
  }
}

module "dev-vm-01" {
  source                    = "../_modules/vsphere_vm"
  vm_name                   = "dev-vm-01"
  vm_template               = "deb-12-template"
  network_spec = {
    network_id              = "LAN"
  }
  spec = {
    tags                    = [ vsphere_tag.cattle.id, vsphere_tag.linux.id, vsphere_tag.docker.id ]
    folder                  = vsphere_folder.dev.path
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