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
