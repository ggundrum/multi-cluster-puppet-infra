#cloud-config
package_update: true
package_upgrade: true

packages:
  - ansible

write_files:
  - content: |
      ${base64encode("${ansible_playbook}")}
    encoding: b64
    owner: root:root
    path: /opt/ansible-playbook.yml
    permissions: '0750'

runcmd:
 - ansible-playbook /opt/ansible-playbook.yml