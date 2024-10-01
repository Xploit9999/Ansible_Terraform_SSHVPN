module "crear_vpc" {
  source = "git@github.com:Xploit9999/Terraform_modulos.git//digitalocean_vpc"

  nombre_vpc = var.nombre_vpc
  region     = var.region
  ip_rango   = var.ip_rango
}

module "creacion_droplet" {
  source = "git@github.com:Xploit9999/Terraform_modulos.git//digitalocean_droplet"

  for_each = var.droplets

  hostname  = each.value.hostname
  recursos  = each.value.recursos
  region    = each.value.region
  so        = each.value.so
  ssh_key   = var.ssh_key
  vpc_id    = module.crear_vpc.vpc_id
  ambiente  = "Desarrollo"
  ingeniero = "John"
  aprovisionamiento = var.aprovisionamiento


  # Vars para aprovisionamiento
  usuarios   = var.usuarios
  paquetes   = var.paquetes
  actualizar = var.actualizar
}

module "reglas_firewall" {
  source = "git@github.com:Xploit9999/Terraform_modulos.git//digitalocean_firewall"

  nombre = var.nombre_fw
  droplets_ids = [ for dp in module.creacion_droplet : dp.droplets_ids[0] ]
  reglas_firewall = var.reglas_firewall
}

resource "digitalocean_project" "sshvpn" {
  name        = var.nombre_proyecto
  description = var.descripcion_proyecto
  purpose     = var.proposito
  environment = var.ambiente
  resources   = concat(
    [ for dp in module.creacion_droplet : "do:droplet:${dp.droplets_ids[0]}" ],
    [ "do:firewall:${module.reglas_firewall.firewall_id}" ]
  )

}
