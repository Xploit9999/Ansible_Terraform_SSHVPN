#cloud-config
%{ if update }
package_update: true
%{ endif }

packages:
%{ for package in packages }
  - ${package}
%{ endfor }

groups:
%{ for group in users_info }
  - ${group.grupo}
%{ endfor }

users:
%{ for user in users_info }
  - name: ${user.nombre}
    gecos: ${user.desc}
    primary_group: ${user.grupo}
    lock_passwd: false
    shell: /bin/bash
    passwd: ${user.pass}
    sudo: ${user.sudo}
    ssh_authorized_keys:
      - ${user.ssh_key} 
%{ endfor }
