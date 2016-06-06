#!/bin/sh

# Forwards a port with iptables rules

ForwardPort(){
    WanInterface=$1
    ExternalPort=$2
    InternalPort=$3
    ServerAddress=$4

    iptables -t nat -A PREROUTING -p tcp  -i $WanInterface --dport $ExternalPort -j DNAT --to-destination $ServerAddress:$InternalPort
    iptables -A FORWARD -p tcp -d $ServerAddress --dport $InternalPort -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
}

ForwardPort $1 $2 $3 $4
