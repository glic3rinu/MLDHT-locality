#!/bin/bash

# Executes command on remote servers, concurrently
#
# USAGE:
#   bash execute.sh "uptime"


while read IP; do
    echo "Querying $IP ..." 1>&2
    ssh -o stricthostkeychecking=no root@$IP "$1" 2> /dev/null &
done
