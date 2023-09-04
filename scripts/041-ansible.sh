#!/bin/sh -eux
apt-get install -y python3-pip
# Workaround for issue https://github.com/ansible-collections/community.digitalocean/issues/132
pip install -Iv 'resolvelib<0.6.0'
apt-get install -y acl ansible-core
