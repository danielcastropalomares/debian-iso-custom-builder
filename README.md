Descargar la ISO de debian:

https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.5.0-amd64-standard.iso

Descargar cubic para ubuntu:
```
	sudo apt-add-repository ppa:cubic-wizard/release
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6494C6D6997C215E
	sudo apt update && sudo apt install cubic
```
Seleccionar un directorio en cubic sobre el que se descoprimira la imagen.
```
~/iso1
```
Cuando el chroot, descargar el script y ejecutar la instalación.

Crear el seed en la pestanya de pressed:
```
:~/iso1$ vi custom-disk/preseed/debian.seed 
```

Editar el menu.cfg para el cargar el seed anterior.
```
~/iso1$ cat custom-disk/isolinux/menu.cfg
INCLUDE stdmenu.cfg
MENU title Main Menu
DEFAULT Debian-Installer-Dani
LABEL Debian-Installer-Dani
  SAY "Booting Debian Installer..."
  linux /d-i/vmlinuz 
  APPEND boot=casper initrd=/d-i/initrd.gz preseed/file=/cdrom/preseed/debian.seed auto=true debian-installer/locale=es_ES keyboard-configuration/layoutcode=es
```