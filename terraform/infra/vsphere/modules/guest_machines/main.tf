#===============================================================================
# vSphere Resources
#===============================================================================

resource "vsphere_virtual_machine" "linux" {
  count = var.spec.os_type == "linux" ? var.instance_count : 0

  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.spec.cpu
  memory   = var.spec.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  sync_time_with_host = true

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
    mac_address  = var.network_spec.mac_address != null ? var.network_spec.mac_address : ""
  }

  disk {
    label            = "${var.vm_name}.vmdk"
    size             = var.spec.disk_size
  }

  dynamic "disk" {
    for_each = var.spec.additional_disks != null ? var.spec.additional_disks : []
    content {
      label            = "extra-disk-${disk.key}"
      size             = disk.value.size
      eagerly_scrub    = false
      thin_provisioned = true
      keep_on_remove   = true
      unit_number      = disk.key + 1
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.spec.linked_clone

    customize {
      timeout = "20"

      linux_options {
        host_name = var.vm_name
        domain    = var.vm_domain
      }

      network_interface {}
    }
  }

  lifecycle {
    ignore_changes = [
      folder,
      disk.0.thin_provisioned,
      disk.0.label,
      clone.0.template_uuid,
      resource_pool_id,
      pci_device_id,
      memory_reservation,
      # until https://github.com/hashicorp/terraform-provider-vsphere/pull/1603
      extra_config,
    ]
  }
}

resource "vsphere_virtual_machine" "windows" {
  count = var.spec.os_type == "windows" ? var.instance_count : 0

  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.spec.cpu
  memory   = var.spec.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  firmware = "efi"

  sync_time_with_host = true

  network_interface {
    network_id   = var.network_spec.network_id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "${var.vm_name}.vmdk"
    size             = var.spec.disk_size
  }

  dynamic "disk" {
    for_each = var.spec.additional_disks != null ? var.spec.additional_disks : []
    content {
      label            = "extra-disk-${disk.key}"
      size             = disk.value.size
      eagerly_scrub    = false
      thin_provisioned = true
      keep_on_remove   = true
      unit_number      = disk.key + 1
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.spec.linked_clone
  }

  lifecycle {
    ignore_changes = [
      folder,
      disk.0.thin_provisioned,
      clone.0.template_uuid,
      resource_pool_id,
      pci_device_id,
      memory_reservation,
      extra_config,
    ]
  }
}
