# Ansible + Terraform SSHVPN

Este proyecto utiliza **Ansible** y **Terraform** para configurar y gestionar una VPN SSH en **DigitalOcean**. El objetivo es automatizar la creación de recursos, la configuración de la VPN y la gestión del firewall.

## Estructura del Proyecto

```
Ansible_Terraform_SSHVPN/
├── config_vars/
│   └── vars.yml
├── crear_recursos/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── provisioning.yaml.tpl
│   └── variables.tf
├── handlers/
│   └── main.yml
├── main.yml
├── roles/
│   └── configure_ssh_vpn/
│       ├── defaults/
│       │   └── main.yml
│       ├── files/
│       │   └── refrescar_conexion.sh
│       ├── handlers/
│       │   └── main.yml
│       ├── meta/
│       │   └── main.yml
│       ├── README.md
│       ├── tasks/
│       │   ├── client_tasks.yml
│       │   ├── droplet_tasks.yml
│       │   ├── main.yml
│       │   └── tunnel.yml
│       ├── templates/
│       │   ├── ssh-tunel.service.j2
│       │   └── tun0.nmconnection.j2
│       ├── tests/
│       │   ├── inventory
│       │   └── test.yml
│       └── vars/
│           └── main.yml
├── tasks/
│   ├── crear_droplet.yml
│   └── destroy.yml
└── templates/
    └── terraform.tfvars.j2

```

## Descripción de Archivos y Carpetas

### `config_vars/vars.yml`

Este archivo contiene las variables necesarias para la configuración del proyecto. Incluye detalles sobre el túnel, dirección IP del cliente y servidor, y las configuraciones para el droplet y el firewall.

### `crear_recursos/`

Esta carpeta contiene los archivos de configuración de **Terraform** que gestionan la creación de los recursos en **DigitalOcean**.

- **`main.tf`**: Archivo principal donde se definen los módulos para crear la VPC, droplets y reglas de firewall.
- **`outputs.tf`**: Define las salidas de los recursos creados, como las IPs de los droplets.
- **`providers.tf`**: Configura el proveedor de **DigitalOcean** para **Terraform**.
- **`provisioning.yaml.tpl`**: Plantilla para la configuración inicial de los droplets.
- **`variables.tf`**: Define todas las variables necesarias para la infraestructura.

### `handlers/main.yml`

Este archivo contiene los handlers utilizados en el rol `configure_ssh_vpn`. Los handlers son tareas que se ejecutan en respuesta a eventos notificados por otras tareas en Ansible, como reiniciar servicios.

### `main.yml`

El archivo principal de Ansible que orquesta la creación y configuración de la VPN. Incluye tareas y condiciones que determinan la ejecución de otras configuraciones.

### `roles/configure_ssh_vpn/`

Contiene todas las configuraciones específicas del rol para configurar la VPN SSH.

- **`defaults/main.yml`**: Variables por defecto para el rol.
- **`files/refrescar_conexion.sh`**: Script Bash para refrescar las conexiones de red.
- **`handlers/main.yml`**: Handlers que se ejecutan en respuesta a cambios en la configuración.
- **`meta/main.yml`**: Metadatos sobre el rol.
- **`tasks/`**: Contiene las tareas específicas para configurar el cliente y el servidor de la VPN.
  - **`client_tasks.yml`**: Tareas para configurar el cliente VPN.
  - **`droplet_tasks.yml`**: Tareas para configurar el droplet en DigitalOcean.
  - **`main.yml`**: Tareas principales del rol.
  - **`tunnel.yml`**: Tareas para crear y configurar el túnel.
- **`templates/`**: Plantillas utilizadas para crear archivos de configuración.
  - **`ssh-tunel.service.j2`**: Plantilla para el archivo de servicio de `systemd`.
  - **`tun0.nmconnection.j2`**: Plantilla para la configuración de la conexión de red.
- **`tests/`**: Contiene pruebas para el rol.
- **`vars/main.yml`**: Variables específicas del rol.

### `tasks/`

Contiene tareas específicas para la creación y destrucción de recursos en DigitalOcean.

- **`crear_droplet.yml`**: Tareas para crear un droplet.
- **`destroy.yml`**: Tareas para eliminar los recursos creados.

### `templates/`

Contiene las plantillas que se utilizan para generar archivos de configuración de Terraform.

- **`terraform.tfvars.j2`**: Plantilla para las variables de Terraform.

## Uso

1. **Configuración**: Asegúrate de que todas las variables necesarias estén configuradas en el archivo **`config_vars/vars.yml`**, ese es el archivo principal para la generación del .tfvars y configuraciones de la VPN.
2. **Ejecución**: Puedes ejecutar el playbook principal usando Ansible:
```bash
   ansible-playbook main.yml -k -K  # Se debe de ejecutar con privilegios.
```
## Opciones

| Parámetro          | Descripción                                                                                             | Requerido | Tipo  | Predeterminado     |
|--------------------|---------------------------------------------------------------------------------------------------------|-----------|-------|--------------------|
| `__tun_name`       | El nombre del túnel que se va a crear.                                                                 | Sí        | str   | `tun0`             |
| `__tun_ip_server`  | La dirección IP del servidor para la conexión del túnel.                                               | Sí        | str   | `10.0.0.3/24`      |
| `__tun_ip_client`  | La dirección IP del cliente para la conexión del túnel.                                               | Sí        | str   | `10.0.0.4/24`      |
| `server`           | La dirección IP pública del servidor donde se configurará el túnel.                                   | Sí        | str   | `xxx.xxx.xxx.xx`   |
| `cliente`          | El nombre de host o dirección IP del cliente, generalmente establecido en `localhost`.                | Sí        | str   | `localhost`        |
| `nombre_proyecto`  | El nombre del proyecto para fines de identificación.                                                  | Sí        | str   | `SSHVPN`           |
| `droplets`         | Define los detalles de los droplets a crear, incluyendo el nombre de host, recursos y sistema operativo.| Sí        | lista | Ver `variables.tf` |
| `usuarios`         | Lista de usuarios que se crearán en el droplet con sus respectivos permisos y claves SSH.            | Sí        | lista | Ver `variables.tf` |
| `reglas_firewall`  | Reglas para configurar el firewall, incluyendo tipos, protocolos y direcciones IP de origen.          | Sí        | lista | Ver `variables.tf` |
| `actualizar`       | Bandera para determinar si se debe actualizar el sistema operativo en la creación del droplet.      | No        | bool  | `true`             |
| `ssh_key`          | La clave SSH utilizada para la autenticación en los droplets.                                         | Sí        | str   | `<tu_clave_ssh>`   |
| `aprovisionamiento` | La ruta a la plantilla de aprovisionamiento que se utilizará para la configuración inicial.            | No        | str   | `provisioning.yaml.tpl` |

## Requisitos

*   **Ansible**: Se requiere que tengas Ansible instalado en tu máquina.
*   **Terraform**: Asegúrate de tener Terraform instalado y configurado para utilizar el proveedor de DigitalOcean.

## Autor

*   **John Freidman**
*   **GitHub**: [@Xploit9999](https://github.com/Xploit9999)

