# COUNTER=0; TOTAL=0; for i in $(cat hops |awk {'print $2'}|grep ','|tr ',' '\n'); do TOTAL=$(($TOTAL+$i)); COUNTER=$(($COUNTER+1)); done; echo "$TOTAL/$COUNTER" | bc
# python -c "import sys; import numpy; a = eval('["%s"]' % sys.argv[1]); print numpy.std(a);" $(cat results/hops |awk {'print $2'}|grep ','|tr ',' '\n'|tr '\n' ',')
# AVG = 7
#cat nodes.list | while read IP; do scp -o stricthostkeychecking=no traceroute.sh root@[$IP]: & done
#cat nodes.list | bash execute.sh "bash traceroute.sh" > results/hops


IPS="10.139.40.123 "$(cat bootstrap_unstable|awk {'print $1'})
HOPS=""

for IP in $(echo -n "$IPS"); do
    ping -c 1 $IP -w 3 &> /dev/null &&
    HOPS="$HOPS $(traceroute -w 1 -n $IP | tail -n1 | awk {'print $1'} 2> /dev/null)"
done

echo "$(hostname) $(echo $HOPS | tr ' ' ',')"
