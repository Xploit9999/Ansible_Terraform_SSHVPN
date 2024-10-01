output "droplets_ips" {
  value = [for vm in module.creacion_droplet : vm.get_ip]
}

