provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true

  lxd_remote {
    name     = "tjp1"
    address  = "88.200.23.239"
    password = var.lxdremote_password
    port     = "8443"
    scheme   = "https"
    default  = "true"
  }
}
