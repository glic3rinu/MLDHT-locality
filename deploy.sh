#!/bin/bash

# Deploys experiment
#
# USAGE:
#   cat nodes.list | bash deploy.sh EXPNUM
#
# REQUIRES:
#   python get-mgmt-ips.py SLICE_ID > nodes.list
#   cat nodes.list | bash execute.sh "ifconfig pub0|grep 'inet addr:'|cut -d':' -f2" | sed "s/ Bcast/17000/" > bootstrap_unstable
#
# ABORT:
#   cat nodes.list | bash execute.sh 'pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh'


BOOTSTRAP="10.139.40.123"
COUNTER=0
IDS_PER_NODE=1
IPS=''
EXPNUM=$1

while read IP; do
    IPS="$IPS\n$IP"
    COUNTER=$(($COUNTER+1))
done

IPS=$(echo "$IPS" | grep -v '^$')


# ID[$IDS_PER_NODE*$COUNTER] = Node info hashes
echo "
import identifier
for i in range($IDS_PER_NODE*$COUNTER+1):
    print(repr(identifier.RandomId()))

" | python > /tmp/infohashes.list


# ID(0) = info_hash
# ID(>0) = Node ID
echo "
import identifier
base_ident = repr(identifier.RandomId())
for i in range($COUNTER+2):
    ident = repr(identifier.RandomId())
    ident = base_ident[:30] + ident[30:]
    print(ident)

" | python > /tmp/infohashes2.list
cp /tmp/infohashes2.list /tmp/infohashes3.list
cp /tmp/infohashes$EXPNUM.list /tmp/infohashes.list


FILES="/tmp/infohashes.list bootstrap_unstable experiment$EXPNUM.sh collect.sh"


COUNTER=0
echo -e "$IPS" | while read IP; do
    { echo "$IP" &&
      scp -o stricthostkeychecking=no $FILES root@[$IP]: &&
      ssh root@$IP 'pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh' ;
      CMD="nohup bash experiment$EXPNUM.sh $BOOTSTRAP $COUNTER $IDS_PER_NODE" &&
      echo "$CMD" ;
      ssh root@$IP "$CMD" ;
      echo "clossing ssh connection" ;
    } &> "/tmp/exp-$COUNTER.log" &
    COUNTER=$(($COUNTER+1))
done
