#!/bin/bash

# CRONTAB: 0 0,6,12,18 * * * cd /var/www; bash monitor.sh


SLICE_ID=${1:-365}


CMD=$(cat <<- EOF
	SLICE_ID = $SLICE_ID
	from orm.api import Api
	controller = Api("https://controller.community-lab.net/api/")
	slivers = controller.slivers.retrieve()
	slivers.retrieve_related("node", "slice")
	slivers = slivers.filter(slice__id=SLICE_ID)
	
	# 0. Adds new slivers to SLICE_ID
	nodes = controller.nodes.retrieve()
	new_nodes = nodes.exclude(id__in=slivers.values_list('node__id'))
	slice = slivers[0].slice
	password = open('/root/.confine_password').read().strip()
	controller.login(username='health', password=password)
	interfaces = [
	    {
	        'type': 'private',
	        'name': 'priv0'
	    }, {
	        'type': 'public4',
	        'name': 'pub0'
	    }
	]
	for node in new_nodes:
	    sliver = controller.slivers.create(slice=slice, node=node, interfaces=interfaces)
	    slivers.append(sliver)
	
	# 1. Gets all mgmt IPs of SLICE_ID slivers
	MGMT_IPV6_PREFIX = controller.testbed_params.mgmt_ipv6_prefix
	int_to_hex_str = lambda i,l: ("%." + str(l) + "x") % i
	split_by_len = lambda s,l: [s[i:i+l] for i in range(0, len(s), l)]
	for sliver in slivers:
	    node_id = sliver.node.id
	    slice_id = sliver.slice.id
	    for iface in sliver.interfaces:
	        if iface.type == "management":
	            nr = "10" + int_to_hex_str(iface.nr, 2)
	            node_id = int_to_hex_str(node_id, 4)
	            slice_id = int_to_hex_str(slice_id, 12)
	            ipv6_words = MGMT_IPV6_PREFIX.split(":")[:3]
	            ipv6_words.extend([node_id, nr])
	            ipv6_words.extend(split_by_len(slice_id, 4))
	            print ":".join(ipv6_words)
	            break
	EOF
	)

SLIVERS=$(python -c "$CMD")


# 2. Gets all the public IPs of SLICE_ID slivers
CMD="/sbin/ifconfig pub0|grep 'inet addr:'|cut -d':' -f2 | sed 's/ Bcast//'"
PUBLIC_ADDRESSES=$(echo -e "$SLIVERS" | while read IP; do
		ssh -i ~/.ssh/confine -o stricthostkeychecking=no root@$IP "$CMD" 2> /dev/null &
	done)


# 3. Performs a full-mesh traceroute of every sliver in SLICE_ID
echo -e "$SLIVERS" | while read IP; do
    {
      cat <<- EOF | ssh -t -q -i ~/.ssh/confine -o stricthostkeychecking=no root@$IP || echo "0000000000f9_"$(echo $IP|cut -d':' -f4)
		for IP in \$(echo -n "$PUBLIC_ADDRESSES"); do
		    HOP=0
		    ping -c 1 -w 3 \$IP &> /dev/null && HOP=\$(traceroute -w 1 -n \$IP | tail -n1 | awk {'print \$1'} 2> /dev/null)
		    HOPS="\$HOPS \$HOP"
		done

		INTERNET=0
		ping -c 1 8.8.8.8 -w 5 &> /dev/null && INTERNET=1
		HOSTNAME=\$(hostname 2> /dev/null || grep hostname /etc/config/system|awk {'print \$3'} 2> /dev/null)
		echo "\$HOSTNAME \$INTERNET \$(echo \$HOPS | tr ' ' ',')"
		EOF
    } &
done | grep ^0000000 > results.txt.tmp


# 4. Analizes the results and formats them on HTML
CMD=$(cat <<- EOF
	import sys
	import time
	from datetime import datetime
	
	SLICE_ID = $SLICE_ID
	
	slivers = 0
	internet = 0
	connectivity = 0
	disconnected = 0
	partial = 0
	avg_hops = 0
	links = 0
	offline = 0
	healthy = 0
	islands = []
	pending = None
	
	def print_data(context):
	    for line in context:
	        if not line:
	            print '<br>'
	            continue
	        elif len(line) == 2:
	            line += [False]
	        name, value, bold = line
	        spaces = 50-len(name)-len(value)
	        line = name + ' '*(spaces%2) + ' .'*(spaces/2) + ' ' + value + '<br>'
	        if bold:
	            line = "<b>%s</b>" % line
	        print line
	
	with open("results.txt.tmp", "r") as results:
	    for line in results.readlines():
	        slivers += 1
	        if len(line.split()) != 3:
	            offline += 1
	            continue
	        
	        hostname, _internet, hops = line.split()
	        hops = [int(value) for value in hops.split(',')]
	        internet += int(_internet)
	        online = 0
	        _links = 0
	        for hop in hops:
	            _links += 1
	            avg_hops += hop
	            if hop != 0:
	                online += 1
	        
	        connectivity += online
	        links += _links
	        
	        if online < 2:
	            disconnected += 1
	        elif online < _links/2:
	            partial += 1
	        elif _internet == '1':
	            healthy += 1
	        
	        if pending is None:
	            pending = range(len(hops))
	        _pending = []
	        new_island = 0
	        for ix in pending:
	            if hops[ix] == 0:
	                _pending.append(ix)
	            else:
	                new_island += 1
	        pending = _pending
	        if new_island > 1:
	            islands.append(new_island)
	    
	    online = (slivers-offline)
	    connected = online-partial-disconnected
	    data = [
	        ["SLIVERS", str(slivers)],
	        ["HEALTHY", "%s/%s %.2f%%" % (healthy, slivers, float(healthy)/slivers*100), True],
	        [],
	        ["ONLINE", "%s/%s %.2f%%" % (online, slivers, float(online)/slivers*100)],
	        ["OFFLINE", "%s/%s %.2f%%" % (offline, slivers, float(offline)/slivers*100)],
	        ["INTERNET CONNECTION", "%s/%s %.2f%%" % (internet, online, float(internet)/online*100)],
	        ["DISCONNECTED", "%s/%s %.2f%%" % (disconnected, online, float(disconnected)/online*100)],
	        ["PARTIALLY CONNECTED", "%s/%s %.2f%%" % (partial, online, float(partial)/online*100)],
	        ["WELL CONNECTED", "%s/%s %.2f%%" % (connected, online, float(connected)/online*100)],
	        [],
	        ["CONNECTIVITY FACTOR", "%.2f" % (float(connectivity)/links)],
	        ["AVG HOPS", "%.2f" % (float(avg_hops)/connectivity)],
	        ["ISLANDS", str(islands), True],
	    ]
	    
	    print "<html><body><center><pre><br><br><h1>Slivers Connectivity Status</h1>"
	    print "Generated on %s %s" % (datetime.now().strftime("%B %d, %Y %H:%M:%S"), time.tzname[0])
	    print "<br>"
	    print "<a href=\"https://controller.community-lab.net/admin/slices/slice/%i\">SLICE %i</a><br>" % (SLICE_ID, SLICE_ID)
	    print_data(data)
	    print "<br>"
	    print "<a href=\"results.txt\">Dataset</a> <a href=\"monitor.sh\">Code</a> <a href=\"public_addresses\">Public addresses</a>"
	    print "</pre></center></body></html>"
	EOF
	)


python -c "$CMD" > summary.html.tmp && {
    mv results.txt.tmp results.txt
    mv summary.html.tmp summary.html
    echo "$PUBLIC_ADDRESSES" > public_addresses
}

