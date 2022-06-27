# VMGenerator

Terraform script to generate multiple VMs at once

## Prerequisites

The only dependency for this project is Terraform. Instructions on how to install it are available [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

## Configuration

Have a look at `cloud-init.yml` and configure it for your own need. You can find more information about cloud-init [here](https://cloudinit.readthedocs.io/en/latest/index.html).
Make sure you change `ssh_import_id` parameter, otherwise I can potentially access you VM, if accesible.

## Run

Once you have Terraform installed, run:

    terraform apply -var-file="config.tfvars"
    
in order to deploy the `main.tf` configuration.
