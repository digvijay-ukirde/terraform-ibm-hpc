output "scale" {
  value = module.scale
}

output "scale_compute_subnet" {
  description = "Scale compute subnet"
  value       = module.scale.landing_zone.compute_subnets
}

output "scale_filesystems" {
  description = "Filesystem for Scale storage cluster"
  value       = var.filesystem_config[*]["filesystem"]
}

output "scale_filesets" {
  description = "Filesets for Scale storage cluster"
  value       = var.filesets_config[*]["fileset"]
}

output "scale_exports" {
  description = "Scale storage cluster exports"
  value =  "${var.dns_domain_names["protocol"]}:${var.filesets_config[0]["junction_path"]}"
  # value = [for fileset in filesets_config: "${var.dns_domain_names["protocol"]}:${fileset["junction_path"]}" ]
}