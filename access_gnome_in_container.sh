# 
docker run -d -p 5900:5900 -p 5901:5901 --name="vnc-centos7" --privileged=true centos:7 /usr/sbin/init

#
docker exec -it centos7 /bin/bash

# Below activities need to be executed inside the container
systemctl get-default

systemctl set-default graphical.target
# systemctl set-default multi-user.target to set back startup mode

systemctl stop firewalld

yum update -y

yum groupinstall "GNOME Desktop" "X Window System" "Desktop"

yum install tigervnc-server tigervnc vnc vnc-server

cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service

vim /etc/systemd/system/vncserver@:1.service

# Replace root and /root
ExecStart=/sbin/runuser -l root -c "/usr/bin/vncserver %i"	PIDFile=/root/.vnc/%H%i.pid

vncpasswd

vim /etc/libvirt/qemu.conf 

# Remove # ahead of below 2 items
vnc_password = "XYZ123"
vnc_listen = "0.0.0.0"

systemctl daemon-reload

vncserver

# Execute below command to shutdown vnc
# vncserver -kill :1


# Now the vnc in container has been startup, the next step will configure a openvpn in order to mac host can reach the container

brew install tunnelblick

git clone https://github.com/wojas/docker-mac-network.git

vim docker-mac-network/helpers/run.sh

# change ip range and mask according to your actual. Mine is 192.168.250.0/24
# s|redirect-gateway.*|route 192.168.250.0 255.255.255.0|;

docker-compose up

# Then you can find a file in docker-mac-network names docker-for-mac.vpn

vim docker-for-mac.vpn

# add 'comp-lzo yes' similar to below
# </tls-auth>
# comp-lzo yes
# route 192.168.250.0 255.255.255.0

# drop the config file to the tunnelblick then click connect, now your mac host can reach the container
