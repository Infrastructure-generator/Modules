data "template_file" "cloudinit_file" {
  template = file("cloud-init.yml")
}
