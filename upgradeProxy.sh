#!/bin/bash
if [ "$1" == "" ] ; then
        echo "Argument missing usage: <version number>"
        exit 0
fi

echo -e "Get the last release"
wget https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/$1/dnscrypt-proxy-linux_arm-$1.tar.gz

echo -e "unpack if download was successful otherwise exit"
FILE=dnscrypt-proxy-linux_arm-$1.tar.gz
if test -f "$FILE"; then
        tar -xvzf "$FILE"
else
        echo -e "Download didn't work"
        exit 1
fi

echo -e "remove old backup"
OLDBackup=/opt/dnscrypt-proxy/dnscrypt-proxy.bak
if test -f "$OLDBackup"; then
        sudo rm "$OLDBackup"
fi

echo -e "create new backup"
sudo cp /opt/dnscrypt-proxy/dnscrypt-proxy /opt/dnscrypt-proxy/dnscrypt-proxy.bak

echo -e "delete old version"
sudo rm /opt/dnscrypt-proxy/dnscrypt-proxy

echo -e "move new release over"
sudo cp linux-arm/dnscrypt-proxy /opt/dnscrypt-proxy/dnscrypt-proxy

echo -e "restart service"
sudo service dnscrypt-proxy restart

echo -e "clean up"
rm "$FILE"
rm -rf linux-arm/*
rmdir linux-arm