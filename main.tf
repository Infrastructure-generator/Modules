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

locals {
  grouped_instances = [
    for instance in jsondecode(var.configuration) : [
      for i in range(1, instance.count + 1) : {
        "name"  = "${instance.name}-${i}",
        "image" = instance.image
        "type"  = instance.type
      }
    ]
  ]
  instances = flatten(local.grouped_instances)
}

resource "lxd_project" "project" {
  name        = var.environment
  config = {
    "features.storage.volumes" = false
    "features.images" = false
    "features.profiles" = false
  }
}

resource "lxd_network" "mynetwork" {
  name = "mynetwork"
  config = {
    "ipv4.address" = "10.150.19.1/24"
    "ipv4.nat"     = "true"
    "ipv6.address" = "fd42:474b:622d:259d::1/64"
    "ipv6.nat"     = "true"
  }
  project = lxd_project.project.name
}

resource "lxd_profile" "myprofile" {
  name = "myprofile"
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
      network = "${lxd_network.mynetwork.name}"
    }
  }
  project = lxd_project.project.name
}

resource "lxd_container" "instance" {
  for_each = { for instance in local.instances : instance.name => instance }
  name     = each.value.name
  image    = each.value.image
  type     = each.value.type
  project = lxd_project.project.name
  profiles = ["default", "${lxd_profile.myprofile.name}"]
}
