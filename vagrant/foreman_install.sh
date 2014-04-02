#!/bin/bash

# work around bugs(?) in Facter 1.6.x that reads fqdn domain part from resolv.conf
sudo foreman-installer \
  --enable-foreman \
  --enable-foreman-proxy \
  --enable-puppet \
  --foreman-proxy-puppetrun=true \
  --foreman-proxy-puppetca=true \
  --foreman-proxy-tftp=true \
  --foreman-proxy-dhcp=true \
  --foreman-proxy-dhcp-interface=eth3 \
  --foreman-proxy-dhcp-gateway="172.16.188.11" \
  --foreman-proxy-dhcp-range="172.16.188.100 172.16.188.200" \
  --foreman-proxy-dhcp-nameservers="172.16.188.11" \
  --foreman-proxy-foreman-base-url="https://console.winch.local" \
  --foreman-proxy-oauth-consumer-key="JWxktz8OtcbtIy" \
  --foreman-proxy-oauth-consumer-secret="RTNcT3Jat1FBiA" \
  --foreman-proxy-dns=true \
  --foreman-proxy-dns-interface=eth3 \
  --foreman-proxy-dns-zone="winch.local" \
  --foreman-proxy-dns-reverse="188.16.172.in-addr.arpa"
#    --foreman-proxy-dns           Use DNS (default: false)
#    --foreman-proxy-dns-forwarders  DNS forwarders (default: [])
#    --foreman-proxy-dns-interface  DNS interface (default: "eth0")
#    --foreman-proxy-dns-managed   DNS is managed by Foreman proxy (default: true)
#    --foreman-proxy-dns-reverse   DNS reverse zone name (default: "100.168.192.in-addr.arpa")
#    --foreman-proxy-dns-server    Address of DNS server to manage (default: "127.0.0.1")
#    --foreman-proxy-dns-zone      DNS zone name (default: "Home")
sudo yum -y install rubygem-hammer_cli_foreman
