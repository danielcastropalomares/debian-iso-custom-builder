#!/bin/bash
DATE=$(date +"%d%m%y-%H%M%S")
ISO_URL="https://cdimage.debian.org/debian-cd/11.5.0-live/amd64/iso-hybrid/debian-live-11.5.0-amd64-standard.iso"
ISO_PATH="/vagrant/debian-live-11.5.0-amd64-standard.iso"
ISO_CUSTOM_PATH="/vagrant/Debian-11.5-amd64-custom-$DATE.iso"

if [ ! -f $ISO_PATH ] ; then
	wget $ISO_URL -O $ISO_PATH 
fi

rm -rf /tmp/iso /tmp/iso2

#Install dependencies
apt-get update && apt-get install -y xorriso squashfuse squashfs-tools fakeroot
#Extract the content from the ISO
xorriso -osirrox on -indev $ISO_PATH -extract / /tmp/iso && chmod -R +w /tmp/iso
#Extract isohdpx from iso
dd if=$ISO_PATH bs=1 count=432 of=/tmp/iso/isohdpfx.bin

#Copy and decompress the squashfs filesystem
mkdir /tmp/iso2
cp /tmp/iso/live/filesystem.squashfs /tmp/iso2/
cd /tmp/iso2/
unsquashfs filesystem.squashfs
mount -t proc /proc squashfs-root/proc

#Install packages or edit the system with chroot
cp /vagrant/chroot.sh squashfs-root/
chmod +x squashfs-root/chroot.sh
chroot squashfs-root/ ./chroot.sh
umount squashfs-root/proc
#end

#Delete the old filesystem.squash, compress the new and copy to new destination inside of /tmp/iso
rm -rf /tmp/iso2/filesystem.squashfs
mksquashfs /tmp/iso2/squashfs-root/ /tmp/iso2/filesystem.squashfs -comp xz -b 1M -noappend
cp /tmp/iso2/filesystem.squashfs /tmp/iso/live/

#Copy the custom menu with preseed options and preseed file
cp /vagrant/menu.cfg /tmp/iso/isolinux/menu.cfg
mkdir /tmp/iso/preseed
cp /vagrant/debian.seed /tmp/iso/preseed/debian.seed

#Create the checksum
md5sum /tmp/iso/.disk/info > /tmp/iso/md5sum.txt
sed -i 's|/tmp/iso/|./|g' /tmp/iso/md5sum.txt

#Create the new ISO with custom filesystem.squash in Vagrant directory
cd /tmp/iso
xorriso -outdev $ISO_CUSTOM_PATH -volid PYLIVE -padding 0 -compliance no_emul_toc -map /tmp/iso/ / -chmod 0755 / -- -boot_image isolinux dir=/isolinux -boot_image isolinux system_area=isohdpfx.bin -boot_image any next -boot_image any efi_path=boot/grub/efi.img -boot_image isolinux partition_entry=gpt_basdat


#https://dev.to/otomato_io/how-to-create-custom-debian-based-iso-4g37
#https://www.linuxquestions.org/questions/debian-26/tutorial-creating-a-custom-bootable-debian-live-iso-4175705804/
