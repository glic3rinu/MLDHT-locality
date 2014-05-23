#!/bin/bash

# Deploys experiment
#
# USAGE:
#   cat nodes.list | bash deploy.sh [EXPNUM] [IDS_PER_NODE]
#
# REQUIRES:
#   python get-mgmt-ips.py SLICE_ID > nodes.list
#   cat nodes.list | bash execute.sh "ifconfig pub0|grep 'inet addr:'|cut -d':' -f2" | sed "s/ Bcast/17000/" > bootstrap_unstable
#   . utils.sh; gen_ids $(wc -l nodes.list|awk {'print $1'}) IDS_PER_NODE
#
# ABORT:
#   cat nodes.list | bash execute.sh 'pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh'


BOOTSTRAP="10.139.40.123"
EXPNUM=${1:-1}
IDS_PER_NODE=${2:-1}


FILES="/tmp/infohashes.list bootstrap_unstable experiment$EXPNUM.sh collect.sh"

COUNTER=0
while read IP; do
    { echo "$IP" &&
      scp -o stricthostkeychecking=no $FILES root@[$IP]: &&
      ssh root@$IP 'pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh; pkill -f experiment11.sh' ;
      CMD="nohup bash experiment$EXPNUM.sh $BOOTSTRAP $COUNTER $IDS_PER_NODE" &&
      echo "$CMD" ;
      ssh root@$IP "$CMD" ;
      echo "clossing ssh connection" ;
    } &> "/tmp/exp-$COUNTER.log" &
    COUNTER=$(($COUNTER+1))
done
