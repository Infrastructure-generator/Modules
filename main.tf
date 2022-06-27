terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "1.7.2"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}

data "template_file" "cloudinit_file" {
  template = file("cloud-init.yml")
}

resource "lxd_network" "mynetwork" {
  name = "mynetwork"
  config = {
    "ipv4.address" = "10.150.19.1/24"
    "ipv4.nat"     = "true"
    "ipv6.address" = "fd42:474b:622d:259d::1/64"
    "ipv6.nat"     = "true"
  }
}

resource "lxd_profile" "myprofile" {
  name = "myprofile"
  config = {
    "limits.cpu"             = 2
    "limits.memory"          = "2GiB"
    "user.vendor-data" = data.template_file.cloudinit_file.rendered
  }
  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = "${lxd_network.mynetwork.name}"
    }
  }
}

resource "lxd_container" "freshy" {
  name     = "freshy"
  image    = "ubuntu:20.04"
  type     = "virtual-machine"
  profiles = ["default", "${lxd_profile.myprofile.name}"]
}
