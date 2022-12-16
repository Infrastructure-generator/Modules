# Infrastructure Generator

Combination of Terraform and GitHub to generate and manage multitenant infrastructure

![Infra-generator (1)](https://user-images.githubusercontent.com/48418580/208130113-55fb98cc-915d-4c26-a32c-8562afda79de.png)


## Prerequisites

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [LXD](https://linuxcontainers.org/lxd/getting-started-cli/)

### Additional Setup 

Since the Terraform state needs to be potentially shared among multiple members, we are using Terraform Cloud to keep everyone in sync. Follow the instructions [here](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up) to set it up yourself. Note that we might consider migrating this to a [remote backend](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) in the future.

You also need to make sure your [LXD socket is exposed to the network](https://linuxcontainers.org/lxd/docs/master/howto/server_expose/). Relevant configuration should be applied inside the `main.tf` in order to succefully authenticate with the remote LXD server.


## Configuration

### Terraform

Once you have Terraform installed, have a look at `config.example.tfvars` to see how you can deploy different LXD VM or Container instances.

For available images run:

    lxc image list <remote>

To find available remotes, you can list them using:

    lxc remote list
    
`config.example.tfvars` gets applied to `main.tf` which mainly uses the resources of [terraform-lxd-provider](https://registry.terraform.io/providers/terraform-lxd/lxd/latest/docs). 

### Instance specific configuration

For instance specific configuration have a look at `cloud-init.yml` and configure it for your own need. You can find more information about cloud-init [here](https://cloudinit.readthedocs.io/en/latest/index.html).

Make sure you change `ssh_import_id` parameter, otherwise I can potentially access you VM, if the instance is publicly accesible.

Both admin public key and password-based authentication is enabled.

To replace the value of hashed_passwrd, generate a password yourself using e.g.:

	mkpasswd --method=SHA-512


## How to run

Once you're satisfied with your configuration, you can run:

    terraform apply -var-file="config.example.tfvars"
    
This will run `GitHub Actions` to verify your configuration and deploy it to Terraform Cloud you've setup that should further deploy the resources on to your infrastructure.

## Availability

If you Terraform script is using `cloud-init`, you need to make sure configured image in `config.example.tfvars` has it included. [Here](https://cloudinit.readthedocs.io/en/latest/topics/availability.html) you can find the available distributions. 

**Hint**: Look for images that have `/cloud` appended at the end of the name.

## Pre-commit

This repo is using pre-commit hook to run `terraform fmt` which enforces Terraform best practices and prevents merging misformatted configuration. 
In order to use it, run:

	git config core.hooksPath .githooks
