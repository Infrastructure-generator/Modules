variable "configuration" {
  default     = [{}]
  description = "List of virtual machines and their corresponding configuration"
}

variable "lxdremote_password" {
  description = "LXD remote server password"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "LXD project to scope resources under"
  type 	      = string
}

variable "instances_limit" {
  description = "Maximum number of containers that can be created in the project" 
  type 	      = number
}

variable "cpu_limit" {
  description = "Maximum value for the sum of individual limits.cpu configurations set on the instances of the project" 
  type 	      = number
}

variable "disk_limit" {
  description = "Maximum value of aggregate disk space used by all instances volumes, custom volumes and images of the project" 
  type 	      = string
}

variable "memory_limit" {
  description = "Maximum value for the sum of individual limits.memory configurations set on the instances of the project" 
  type 	      = string
}

variable "networks_limit" {
  description = "Maximum value for the number of networks this project can have" 
  type 	      = number
}
