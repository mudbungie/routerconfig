
# Forward ports.
/etc/network/mudbungie.net/forwardport.sh eth0 1022 22 10.13.1.10 # Katrina ssh
/etc/network/mudbungie.net/forwardport.sh eth0 80 80 10.13.1.20 # webserver
/etc/network/mudbungie.net/forwardport.sh eth0 443 443 10.13.1.20 # webserver
/etc/network/mudbungie.net/forwardport.sh eth0 30565 25565 10.13.1.60 # vm-minecraft-00
/etc/network/mudbungie.net/forwardport.sh eth0 31565 25565 10.13.1.61 # vm-minecraft-01

