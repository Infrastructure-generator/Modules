configuration = [
  {
    "name"  = "vm-ubuntu2004",
    "image" = "images:ubuntu/focal/cloud",
    "type"  = "container",
    "count" = 2
  },
  {
    "name"  = "vm-ubuntu1804",
    "image" = "images:ubuntu/18.04/cloud",
    "type"  = "container",
    "count" = 1
  },
  {
    "name"  = "vm-debian",
    "image" = "images:debian/12/cloud",
    "type"  = "virtual-machine",
    "count" = 3
  },
  {
    "name"  = "vm-centos",
    "image" = "images:centos/9-Stream/cloud",
    "type"  = "virtual-machine",
    "count" = 1
}]
