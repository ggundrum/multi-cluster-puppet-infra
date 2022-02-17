#cloud-config
package_update: true
package_upgrade: true

#cloud-config
# Add groups to the system
# Adds the ubuntu group with members 'root' and 'sys'
# and the empty group hashicorp.
groups:
  - ubuntu: [root,sys]
  - hashicorp

# Add users to the system. Users are added after groups are added.
users:
  - default
  - name: terraform
    gecos: terraform
    shell: /bin/bash
    primary_group: hashicorp
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    lock_passwd: false
  - name: ubuntu
    gecos: ubuntu
    shell: /bin/bash
    primary_group: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users,admin
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC94msJYn78JNsD53//335g5JnUdHRizQoTwkNw5QIYOqmd84X+mK4+s6mWCIv8dXCX0tHCMrjtuNNHtOczwbOj/GLUVLwgQqsYxfu3nYT6Yp+cAQZb8N7s7BWYffL/l+T9L37AvYVA35aok//dcmAiDdBvrSdCXFCLczfvtTnK++XvyvEZgpzk+McypYJV9aS1gm1METL+qotTTgHcYNdc+rYDfvZ4m74qsU4nmEJ6eNuSPzjq5KX78vSXc0fPA3c6t0BxHsZBqK1QAythrGBryoT31nIXJEMiFxCaQKbqxO34iuL6MYdaYImZW6t7rEMppXpMzIFxbUQmcckrhwF51i519kDPKW4/H5j7rrR3jcUrd7bkJ4wxMAMIUaZRQ6S0dZif5gGbYUqS1sbqIN3ZbQnPPwCR8JobfQAlORL9xpdvMLdhWCWCk9WbrdVMA/V5NdUwBUtcy/1n/HVn1F0mU+XCtXrsOydrabKnjeMN2wGOBDm63bc5iXzUggQj8jWHT+omp10UND/AmQThYORbEvlyldkuGt9DrI9YX3zyxwg/mK+EXMQgL4myQp0X4Wr3KQytJVORn0zYI7OWFmGZtpt47hSpOWXWGKCiXxpOERgyuLfJ+KpqIdVlDuJQlIiMUja+di7QtI9oYePJaUiCqkf8PHUVPaPpM+SXTQJOGQ==

runcmd:
 - su - ubuntu
 - cd /home/ubuntu
 - whoami > whoami.txt
 - pwd > /tmp/pwd.txt
 - curl -sSL https://k8s.kurl.sh/puppet-application-manager-standalone | sudo bash | tee -a installcd4pe.txt