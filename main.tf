terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "1.9.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }

  backend "remote" {
    organization = "rk-lab-fri"

    workspaces {
      prefix = "fri-"
    }
  }
}

provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true

  lxd_remote {
    name     = "tjp1"
    address  = "88.200.23.239"
    password = var.lxdremote_password
    port     = "8443"
    scheme   = "https"
    default  = "true"
  }
}

data "template_file" "cloudinit_file" {
  template = file("cloud-init.yml")
}

resource "lxd_project" "project" {
  name        = var.environment
  config = {
    "features.storage.volumes" = false
    "features.images" = false
    "features.profiles" = false
  }
}

locals {
  grouped_instances = [
    for instance in jsondecode(var.instances) : [
      for i in range(1, instance.count + 1) : {
        "name"    = "${instance.name}-${i}",
        "image"   = instance.image,
        "type"    = instance.type,
	"profile" = instance.profile,
      }
    ]
  ]
  instances = flatten(local.grouped_instances)

  grouped_networks = [
    for network in jsondecode(var.networks) : [
      {
        "name"  = "${network.name}",
      }
    ]
  ]
  networks = flatten(local.grouped_networks)

  grouped_profiles = [
    for profile in jsondecode(var.profiles) : [
      {
        "name"  = "${profile.name}",
        "network"  = "${profile.network}",
      }
    ]
  ]
  profiles = flatten(local.grouped_profiles)
}

resource "lxd_network" "network" {
  for_each = { for network in local.networks : network.name => network }
  name     = each.value.name
  project = lxd_project.project.name
  config = {
    "ipv4.address" = "10.150.20.1/24"
    "ipv4.nat"     = "true"
  }
}

resource "lxd_profile" "profile" {
  for_each = { for profile in local.profiles : profile.name => profile }
  name     = each.value.name
  project = lxd_project.project.name
  config = {
    "limits.cpu"          = 2
    "limits.memory"       = "2GiB"
    "user.vendor-data"    = data.template_file.cloudinit_file.rendered
    "security.secureboot" = false
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = each.value.network 
    }
  }

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
    }
  }
}

resource "lxd_container" "instance" {
  for_each = { for instance in local.instances : instance.name => instance }
  name     = each.value.name
  image    = each.value.image
  type     = each.value.type
  project = lxd_project.project.name
  profiles = [ "default", each.value.profile ]
}
