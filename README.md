# Requirements
This is a Vagrant file to decompress and modify Debian ISO.

Tested in:
```
ii  vagrant                                    2.2.6+dfsg-2ubuntu3                           all          Tool for building and distributing virtualized development environments
ii  virtualbox-6.1                             6.1.32-149290~Ubuntu~eoan                     amd64        Oracle VM VirtualBox
```

And Ubuntu 22.04 LTS:
```
/etc/issue
Ubuntu 20.04.4 LTS \n \l
```

# Files

* chroot.sh: Modify the chroot script to add some packages inside of the image
* debian.seed: The ISO generate by this vagrant include a debian seed for the installation. All the installation process is unattended and you can edit the configuration inside of this file.
* menu.cfg: added kernel line to boot with debian.seed.
* create-image.sh: the all the instructions to decompress modify and compress the image are inside of this script. You can modify the version of the ISO here.



# How to create a new Debian Image

Clone this repository:
```
git clone https://github.com/danielcastropalomares/debian-iso-custom-builder.git
```
And execute vagrant:
```
cd debian-iso-custom-builder
Vagrant up
```

The ISO genetared by vagrant is saved in the same directory:

```
~/git/debian-iso-custom-builder$ ls -liath Debian-11.5-amd64-custom-111022-193851.iso
8393700 -rw-r--r-- 1 danicastro danicastro 1,1G oct 11 21:48 Debian-11.5-amd64-custom-111022-193851.iso

```

