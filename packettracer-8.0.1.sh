#!/bin/bash
echo ""
echo "Downloading the file Cisco Packet Tracer - 8.0.1" && curl --progress-bar --remote-name --location "https://archive.org/download/cisco-packet-tracer-801-ubuntu-64bit/CiscoPacketTracer_801_Ubuntu_64bit.deb"
DIR="/tmp/PacketTracer/"
if [ -d "$DIR" ]; then
	rm -rf "$DIR"
else
	mkdir /tmp/PacketTracer/
fi
mv CiscoPacketTracer_801_Ubuntu_64bit.deb /tmp/PacketTracer/CiscoPacketTracer_801_Ubuntu_64bit.deb
cd /tmp/PacketTracer/
ar -xv CiscoPacketTracer_801_Ubuntu_64bit.deb
mkdir control
tar -C control -Jxf control.tar.xz
mkdir data
tar -C data -Jxf data.tar.xz
cd data
#Remove the current installation of Packet Tracer (usually installed in /opt/pt).
rm -rf /opt/pt
rm -rf /usr/share/applications/cisco-pt7.desktop
rm -rf /usr/share/applications/cisco-ptsa7.desktop
rm -rf /usr/share/icons/hicolor/48x48/apps/pt7.png
#Copy Packet Tracer files.
yes | cp -r usr /
yes | cp -r opt /
#Symbolic link to a required library.
ln -s /usr/lib64/libdouble-conversion.so.3.1.5 /usr/lib64/libdouble-conversion.so.1
#Update icon and file association.
xdg-desktop-menu install /usr/share/applications/cisco-pt.desktop
xdg-desktop-menu install /usr/share/applications/cisco-ptsa.desktop
update-mime-database /usr/share/mime
gtk-update-icon-cache --force --ignore-theme-index /usr/share/icons/gnome
xdg-mime default cisco-ptsa.desktop x-scheme-handler/pttp
#Symbolic link for Packet Tracer.
ln -sf /opt/pt/packettracer /usr/local/bin/packettracer
#Set environment variables.
cat << "EOF">> /etc/profile.local
PTHOME=/opt/pt
export PTHOME
QT_DEVICE_PIXEL_RATIO=auto
export QT_DEVICE_PIXEL_RATIO
EOF
#Remove files used during installation process.
rm -rf /tmp/PacketTracer
echo ""
echo "Hit <ENTER> to continue."
echo ""
read 
echo "Done..!"
echo ""
echo ""
