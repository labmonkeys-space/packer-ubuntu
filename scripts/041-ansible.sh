#!/bin/sh -eux
apt-get install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible

# Package acl is required because of none world readable tmp files and prevents error message during setting the SCRAM-SHA-256
# on PostgreSQL:
#   Failed to set permissions on the temporary files Ansible needs to create when becoming an unprivileged user.
apt-get install -y acl ansible
