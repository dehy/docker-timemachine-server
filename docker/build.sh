#!/bin/bash

set -eux

echo "DEBUG: $DEBUG"

export DEBIAN_FRONTEND=noninteractive
DEBUG=${DEBUG:-0}

apt-get update
apt-get install -y --no-install-recommends avahi-daemon supervisor

# Samba build
apt-get install -y --no-install-recommends python python-dev libacl1-dev \
    build-essential vim curl ca-certificates

mkdir -p /build
cd /build
curl -L https://github.com/samba-team/samba/archive/master.tar.gz -o samba-master.tar.gz
tar xvf samba-master.tar.gz

cd samba-master
./configure \
    --disable-cups \
    --disable-iprint \
    --without-systemd \
    --without-ldap \
    --without-ads \
    --without-ad-dc \
    --without-pam \
    --prefix=/usr \
    --exec-prefix=/usr \
    --sysconfdir=/etc \
    --libdir=/usr/lib/aarch64-linux-gnu \
    --localstatedir=/var \
    --enable-fhs \
    --enable-avahi

make -j $(nproc) && make -j $(nproc) install

mkdir -p /etc/samba/security

groupadd timemachine

if [ "$DEBUG" == "0" ]; then
    apt-get purge -y python-dev libacl1-dev curl vim build-essential
    apt-get autoremove -y
fi

exit 0