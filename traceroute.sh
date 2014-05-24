#cat nodes.list | while read IP; do scp -o stricthostkeychecking=no traceroute.sh root@[$IP]: &; done
#cat nodes.list | bash execute.sh "bash traceroute.sh" > hops


IPS="10.139.40.123 "$(cat bootstrap_unstable|awk {'print $1'})

for IP in $(echo -n "$IPS"); do
    ping -c 1 $IP -w 7 &> /dev/null &&
    traceroute -w 1 -n $IP | tail -n1 | awk {'print $1'} 2> /dev/null
done
