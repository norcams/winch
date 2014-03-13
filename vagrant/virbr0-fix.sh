#!/bin/sh
# Remove virbr0 if it exists
virsh net-autostart default --disable >/dev/null 2>&1
virsh net-destroy default >/dev/null 2>&1

# Always exit with 0
exit 0

