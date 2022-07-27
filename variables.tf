variable "configuration" {
  default     = [{}]
  description = "List of virtual machines and their corresponding configuration"
}

variable "lxdremote_password" {
  description = "LXD remote server password"
  type        = string
  sensitive   = true
}
