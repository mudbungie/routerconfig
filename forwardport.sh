#!/bin/sh

# Forwards a port with iptables rules

ForwardPort(){
    WanInterface=$1 # The interface that the packet is hitting
    ExternalPort=$2 # The port of the incoming packet
    InternalPort=$3 # The port that it should hit on the server
    ServerAddress=$4 # The address of the destination server

    LanAddress=$(ip route get $ServerAddress |head -n 1 | tr -s ' ' |cut -d ' ' -f 5)
    LanInterface=$(ip route get $ServerAddress |head -n 1 | tr -s ' ' |cut -d ' ' -f 3)

    WanAddress=$(ip addr show $WanInterface |grep inet |head -n 1|tr -s ' ' |cut -d ' ' -f 3 |cut -d '/' -f 1)
    WanNetmask=$(ip addr show $WanInterface |grep inet |head -n 1|tr -s ' ' |cut -d ' ' -f 3 |cut -d '/' -f 2)

    echo $LanAddress $LanInterface

    # Allow SYN packets to hit the destination.
    iptables -A FORWARD -i $WanInterface -o $LanInterface -p tcp --syn --dport $InternalPort -m conntrack --ctstate NEW -j ACCEPT
    iptables -A FORWARD -o $LanInterface -p tcp --syn --dport $InternalPort -m conntrack --ctstate NEW -j ACCEPT
    # Translate to an internal address and port.
    iptables -t nat -A PREROUTING -p tcp -d $WanAddress --dport $ExternalPort -j DNAT --to-destination $ServerAddress:$InternalPort
    #iptables -t nat -A PREROUTING -i $WanInterface -p tcp --dport $ExternalPort -j DNAT --to-destination $ServerAddress:$InternalPort
    # Modify the source address to be the internal interface.
    iptables -t nat -A POSTROUTING -o $LanInterface -p tcp --dport $InternalPort -d $ServerAddress -j SNAT --to-source $LanAddress

}

ForwardPort $1 $2 $3 $4
