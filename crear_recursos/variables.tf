variable "nombre_proyecto" {
  type = string
}

variable "descripcion_proyecto" {
  type = string
}

variable "proposito" {
  type = string
}

variable "ambiente" {
  type = string
}

variable "nombre_vpc" {
  type = string
}

variable "region" {
  type = string
}

variable "ip_rango" {
  type = string
}

variable "droplets" {
  description = "Definición de droplets y sus recursos"
  type = map(object({
    hostname = string
    recursos = string
    region   = string
    so       = string
  }))

  default = {
    droplet1 = {
      hostname = "testing1"
      recursos = "s-1vcpu-1gb"
      region   = "nyc1"
      so       = "almalinux-9-x64"
    }
  }
}

variable "usuarios" {
  type = list(object({
    nombre = string
    desc   = string
    grupo  = string
    pass   = string
    sudo   = string
    ssh_key = string
  }))

  default = [{
    nombre = "John"
    desc   = "Ingeniero UNIX"
    grupo  = "sysadm"
    pass   = "$6$XGPXU9OG5aldbR6p$vAXFSTFNdM12pOGwAebcEtTgFFgWd1CnUeDCEG517hETyLSQLCGR1gE9ehfzmF3eB8ifDMqzASi6ntx13zeou0"
    sudo   = "ALL=(ALL) PASSWD: ALL"
    ssh_key = ""

  }]
}

variable "paquetes" {
  type = list(any)

  default = ["iotop"]
}

variable "actualizar" {
  type = bool

  default = false
}

variable "ssh_key" {}

variable "reglas_firewall" {
  type = list(object({
    tipo      = string
    protocolo = string
    puertos   = string
    origen    = list(string)
  }))

  default = [
    {
      tipo      = "inbound"
      protocolo = "tcp"
      puertos   = "22"
      origen    = ["192.168.1.0/24"]
    }
  ]
}

variable "nombre_fw" {
  type  = string
  default = "mi_firewall"
}

variable "aprovisionamiento" {
  type = string
  default = ""
}
