# VMGenerator

Terraform script to generate multiple VMs at once

## Pre-commit

This repo is using pre-commit hook to run `terraform fmt` which enforces Terraform best practices and prevents merging misformatted configuration. In order to utilize precommit hook, run:

	git config core.hooksPath .githooks

## Prerequisites

The only dependency for this project is Terraform and LXD. Instructions on how to install it are available [here](https://learn.hashicorp.com/tutorials/terraform/install-cli) and [here](https://linuxcontainers.org/lxd/getting-started-cli/).

## Configuration

For instance specific configuration have a look at `cloud-init.yml` and configure it for your own need. You can find more information about cloud-init [here](https://cloudinit.readthedocs.io/en/latest/index.html).
Make sure you change `ssh_import_id` parameter, otherwise I can potentially access you VM, if accesible.

### cloud-init

Both admin public key and password-based authentication is enabled.
To replace the value of hashed_passwrd, generate a password yourself using e.g.:

	mkpasswd --method=SHA-512

## Run

Once you have Terraform installed, have a look at `config.example.tfvars` to see how you can deploy different VMs and then run:

    terraform apply -var-file="config.example.tfvars"
    
in order to deploy the `main.tf` configuration. For available images run:

    lxc image list <remote>

Additionally, you can list available remotes using:

    lxc remote list

## Availability

Since the script is using `cloud-init`, you need to make sure configured image works with it. [Here](https://cloudinit.readthedocs.io/en/latest/topics/availability.html) you can find the available distributions.

Also while choosing an image, it must have `/cloud` appended at the end, otherwise `cloud-init` is not available in the image and terraform cannot configure the instance.
