# Infrastructure Generator

Combination of Terraform and GitHub Actions Scripts to generate and manage infrastructure

## Pre-commit

This repo is using pre-commit hook to run `terraform fmt` which enforces Terraform best practices and prevents merging misformatted configuration. 
In order to use it, run:

	git config core.hooksPath .githooks

## Prerequisites

The only dependency for this project are [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and [LXD](https://linuxcontainers.org/lxd/getting-started-cli/). Follow the instructions in the links to install them.

## Configuration

### Terraform configuration

Once you have Terraform installed, have a look at `config.example.tfvars` to see how you can deploy different LXD VMs or Containers.

For available images run:

    lxc image list <remote>

Additionally, you can list available remotes using:

    lxc remote list

### Instance specific configuration

For instance specific configuration have a look at `cloud-init.yml` and configure it for your own need. You can find more information about cloud-init [here](https://cloudinit.readthedocs.io/en/latest/index.html).

Make sure you change `ssh_import_id` parameter, otherwise I can potentially access you VM, if the instance is publicly accesible.

#### cloud-init

Both admin public key and password-based authentication is enabled.

To replace the value of hashed_passwrd, generate a password yourself using e.g.:

	mkpasswd --method=SHA-512

## Run

Once you're satisfied with your configuration, you can run:

    terraform apply -var-file="config.example.tfvars"
    
This will apply your configuration to the main.tf and execute it.

## Availability

Since the script is using `cloud-init`, you need to make sure configured image in `config.example.tfvars` has it included. [Here](https://cloudinit.readthedocs.io/en/latest/topics/availability.html) you can find the available distributions. 

**Hint**: Look for images that have `/cloud` appended at the end of the name.
