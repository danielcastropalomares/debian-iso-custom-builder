echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt-get update && apt-get install htop vim ipcalc tcpdump -y
rm -rf /var/cache/apt/archives/*.deb
touch /root/inside.txt
