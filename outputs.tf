output "instances_ip" {
  value       = [for instance in lxd_container.instance : "user@${instance.ipv4_address}"]
  description = "Instances SSH(user + private IP) address"
}
