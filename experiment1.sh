#!/bin/bash

# Install and launch the experiment

set -e

BOOTSTRAP_ADDR=$1
NODE_NUMBER=$2
IDS_PER_NODE=$3

python --version || { apt-get update && apt-get install -y --force-yes git python traceroute ; }

rm -f /root/routing.table
rm -f /tmp/got_peers.log
rm -f /tmp/client.log
rm -rf /root/.pymdht
mkdir -p /root/.pymdht

if [[ ! -d /root/pymdht ]]; then
    echo "Cloning PYMDHT ..."
    git clone https://github.com/rauljim/pymdht.git
    cd pymdht/
else
    cd pymdht/
    git reset --hard
fi

echo "Installing client ..."
echo "
import time
import os
import random
import socket
import struct

from core import pymdht, node, identifier
import plugins.routing_nice_rtt as r_mod
import plugins.lookup_a4 as l_mod
import core.exp_plugin_template as e_mod

my_id = identifier.RandomId()
my_node_info = node.Node(('0.0.0.0', 17000), my_id)
pymdht_node = pymdht.Pymdht(my_node_info, '/root/.pymdht', r_mod, l_mod, e_mod, None, 1)

def random_peer():
    ip = socket.inet_ntoa(struct.pack('>I', random.randint(1, 0xffffffff)))
    return (ip, 17000)

def _got_peers(l_id, peers, node_):
    with open('/tmp/got_peers.log', 'a') as log:
        log.write(' '.join((str(peers), str(node_))))

while True:
    # Announce node IDs assigned to this NODE_NUMBER
    with open('/root/infohashes.list', 'r') as info_file:
        ini = $NODE_NUMBER*$IDS_PER_NODE
        end = ($NODE_NUMBER+1)*$IDS_PER_NODE
        for info_hash in info_file.readlines()[ini:end]:
            info_hash = identifier.Id(info_hash.strip())
            pymdht_node.controller._tracker.put(info_hash, random_peer())
    
    # Get routing table entries
    rnodes = pymdht_node.controller._routing_m.get_main_rnodes()
    addrs = ','.join([ rnode.addr[0] for rnode in rnodes])
    rtts = ','.join([ '%.2f' % (rnode.rtt*1000) for rnode in rnodes ])
    pid = str(os.getpid())
    timestamp = str(time.time())
    # Log routing table entries
    with open('/root/routing.table', 'a') as log:
        log.write(' '.join((pid, timestamp, addrs, rtts)) + '\n')
    time.sleep(random.randrange(60, 300))
    # Make queries to all IDs
    with open('/root/infohashes.list', 'r') as info_file:
        for info_hash in info_file.readlines():
            info_hash = identifier.Id(info_hash.strip())
            pymdht_node.get_peers(repr(my_id), info_hash, _got_peers)
" > client.py

echo "Patching pymdht..."
# try to prevent minitwisted to crash when address is unreachable ...
sed -i "s/self._all_subnets.remove(utils.get_subnet(addr))/try: self._all_subnets.remove(utils.get_subnet(addr))\n        except KeyError: pass/" core/bootstrap.py
# Adapt bucket dimensioning to our DHT small size
sed -i "s/^DEFAULT_NUM_NODES = 8/DEFAULT_NUM_NODES = 1/" plugins/routing_nice_rtt.py
# Increase cache size
sed -i "s/^CLEANUP_COUNTER = 100/CLEANUP_COUNTER = 1/"  core/tracker.py
# Change routing policy
#sed -i "s/^MAX_NUM_TIMEOUTS = 2/MAX_NUM_TIMEOUTS = -1/" plugins/routing_nice_rtt.py
#sed -i "s/if rtt < rnode.rtt \* (1 - (rnode_age \/ 7200)):/if rtt < rnode.rtt:/" plugins/routing_nice_rtt.py


echo "$BOOTSTRAP_ADDR 17000" > core/bootstrap_stable
cp ../bootstrap_unstable core/bootstrap_unstable

echo "Launching PYMDHT node ..."
bash -c "python client.py 2> /tmp/client.log" &
{ sleep $((60*60)) && kill $(ps aux|grep 'python'|awk {'print $2'}) ; } &
echo "EOF"
exit
