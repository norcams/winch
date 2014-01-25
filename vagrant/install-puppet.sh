#!/bin/bash
# Installs Puppet
#
url=http://folk.uio.no/beddari
filename=puppet-omnibus-3.3.1.fpm0-1.x86_64.rpm

# Check whether a command exists - returns 0 if it does, 1 if it does not
exists() {
    if command -v $1 >/dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

if ! exists puppet;
then
    tmp_dir=$(mktemp -d -t tmp.XXXXXXXX || echo "/tmp")
    curl -L "$url/$filename" > "$tmp_dir/$filename"
    yum install -y "$tmp_dir/$filename"
fi

