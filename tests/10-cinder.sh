echo "CINDER TEST - copy and paste :-)"
echo
echo sudo vgdisplay
echo sudo losetup -a
echo sudo pvdisplay
echo sudo lvdisplay
echo
echo "List only cinder-volumes:"
echo sudo lvdisplay cinder-volumes
echo
echo "Create a cinder volume:"
echo cinder create --display-name testvolume 1
echo "- Look, its magic:"
echo sudo lvdisplay cinder-volumes
echo 
echo "Attaching a volume to an instance:"
echo "nova volume-attach <instance-id> <volume-id> /dev/vdc"
echo "- Log in and verify ..."
echo
echo "Detaching:"
echo "nova volume-list"
echo "- Make sure the volume is unmounted"
echo "- Then detach with"
echo "nova volume-detach <instance-id> <volume_id>"
echo
echo "Deleting a volume:"
echo "nova volume-delete <volume_id>"

