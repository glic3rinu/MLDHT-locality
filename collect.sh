#!/bin/bash

# Process de results
#
# USAGE:
#   cat nodes.list | ./execute.sh "bash collect.sh"


touch /root/routing.hops
cat /root/routing.table | while read line; do
    IPS=$(echo "$line" | awk {'print $3'} | grep -v '^$')
    DISTANCES=""
    for IP in $(echo "$IPS"|sed "s/,/ /g"); do
        if [[ ! $(grep "$IP" /root/routing.hops) ]]; then
            HOPS=$(traceroute -n $IP | tail -n1 | awk {'print $1'})
            echo "$IP $HOPS" >> /root/routing.hops
        fi
        DISTANCES="$DISTANCES $(grep ^$IP /root/routing.hops | awk {'print $2'})"
    done
    HOSTNAME=$(hostname)
    TIMESTAMP=$(echo -n "$line" | awk {'print $2'})
    HOPS=$(echo $DISTANCES | tr ' ' ',')
    RTTS=$(echo "$line" | awk {'print $4'} | grep -v '^$')
    echo $HOSTNAME $TIMESTAMP $HOPS $RTTS
done
