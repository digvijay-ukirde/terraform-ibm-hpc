data "ibm_resource_group" "itself" {
  name = var.resource_group
}

data "ibm_is_image" "bastion" {
  name = var.bastion_image
}

data "ibm_is_image" "deployer" {
  name = var.deployer_image
}

data "ibm_is_ssh_key" "bastion" {
  for_each = toset(var.ssh_keys)
  name     = each.key
}