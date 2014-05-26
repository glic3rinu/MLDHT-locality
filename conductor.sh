source utils.sh

COUNTER=$(wc -l nodes.list|awk {'print $1'})

#python split-nodes.py | bash execute.sh "rm routing.hops"
#sleep 100

#python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
#sleep 180
#killall ssh

#get_two_bucked_ids $COUNTER
#exit

cp /tmp/infohashes.list1 /tmp/infohashes.list
python split-nodes.py | bash deploy.sh 4
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp4.3-cache100-nodes1

sleep 100
python split-nodes.py | bash execute.sh "pkill -f client.py;"
python split-nodes.py | bash execute.sh "pkill -f bash;"
python split-nodes.py | bash execute.sh "pkill -f sleep;"
sleep 80

killall ssh

sed -i 's/DEFAULT_NUM_NODES = 1\/" /DEFAULT_NUM_NODES = 2\/" /' experiment4.sh
cp /tmp/infohashes.list2 /tmp/infohashes.list

python split-nodes.py | bash deploy.sh 4
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp4.2-cache100-nodes2

sleep 100
python split-nodes.py | bash execute.sh "pkill -f client.py;"
python split-nodes.py | bash execute.sh "pkill -f bash;"
python split-nodes.py | bash execute.sh "pkill -f sleep;"
sleep 80

killall ssh


sed -i 's/DEFAULT_NUM_NODES = 2\/" /DEFAULT_NUM_NODES = 3\/" /' experiment4.sh
cp /tmp/infohashes.list3 /tmp/infohashes.list

python split-nodes.py | bash deploy.sh 4
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp4.2-cache100-nodes3

sleep 100
python split-nodes.py | bash execute.sh "pkill -f client.py;"
python split-nodes.py | bash execute.sh "pkill -f bash;"
python split-nodes.py | bash execute.sh "pkill -f sleep;"
sleep 80

killall ssh

sed -i 's/DEFAULT_NUM_NODES = 3\/" /DEFAULT_NUM_NODES = 1\/" /' experiment4.sh

cp /tmp/infohashes.list4 /tmp/infohashes.list
python split-nodes.py 3 0 | bash deploy.sh 4
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 4
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 4
sleep $((20*60))
sleep 100
python split-nodes.py | bash execute.sh "pkill -f client.py;"
python split-nodes.py | bash execute.sh "pkill -f bash;"
python split-nodes.py | bash execute.sh "pkill -f sleep;"

sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp4.2-churn3-cache100-nodes1


sleep 100
killall ssh


sed -i 's/DEFAULT_NUM_NODES = 1\/" /DEFAULT_NUM_NODES = 2\/" /' experiment4.sh
cp /tmp/infohashes.list1 /tmp/infohashes.list

python split-nodes.py 3 0 | bash deploy.sh 4
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 4
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 4
sleep $((20*60))
sleep 100
python split-nodes.py | bash execute.sh "pkill -f client.py;"
python split-nodes.py | bash execute.sh "pkill -f bash;"
python split-nodes.py | bash execute.sh "pkill -f sleep;"

sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp4.2-churn3-cache100-nodes2
sleep 100
killall ssh

exit
# ORIGINAL
sed -i 's/sed -i "s\/if rtt/#sed -i "s\/if rtt/' experiment4.sh
sed -i 's/sed -i "s\/^MAX_NUM_TIMEOUTS/#sed -i "s\/^MAX_NUM_TIMEOUTS/' experiment4.sh


gen_close_ids $COUNTER
python split-nodes.py | bash deploy.sh 3
sleep $((42*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp3.2-cache100-2-original

sleep 180
killall ssh

gen_close_ids $COUNTER
python split-nodes.py | bash deploy.sh 3
sleep $((42*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp3.2-cache100-2-original

sleep 180
killall ssh

gen_ids $COUNTER 1
sed -i 's#CLEANUP_COUNTER = 100/"#CLEANUP_COUNTER = 1/"#' experiment1.sh
python split-nodes.py | bash deploy.sh 1 1
sleep $((42*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-ids1-cache

sleep 180
killall ssh

gen_ids $COUNTER 2
python split-nodes.py | bash deploy.sh 1 1
sleep $((42*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.1-ids1-cache


sleep 180
killall ssh

gen_close_ids $COUNTER
sed -i 's/"102"/"39"/' experiment2.sh
python split-nodes.py 3 0 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2.3-churn3-cache100-node39



sleep 180
killall ssh

sed -i 's/"39"/"102"/' experiment2.sh
gen_close_ids $COUNTER
python split-nodes.py 3 0 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f bash"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2.3-churn3-cache100-node102


sleep 180
killall ssh

gen_close_ids $COUNTER
sed -i 's/"102"/"39"/' experiment2.sh
python split-nodes.py | bash deploy.sh 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f bash"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2.3-cache100-node39



sleep 180
killall ssh

sed -i 's/"39"/"102"/' experiment2.sh
gen_close_ids $COUNTER
python split-nodes.py | bash deploy.sh 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f bash"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2.3-cache100-node102



sleep 180
killall ssh

exit



sed -i 's#CLEANUP_COUNTER = 100/"#CLEANUP_COUNTER = 10000000/"#' experiment11.sh
gen_ids $COUNTER 2
python split-nodes.py | bash deploy.sh 11 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp11-ids2-cache10000000

sleep 300
killall ssh

sed -i 's#CLEANUP_COUNTER = 10000000/"#CLEANUP_COUNTER = 100/"#' experiment1.sh
gen_ids $COUNTER 2
python split-nodes.py | bash deploy.sh 1 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-ids2-cache100

sleep 180
killall ssh

gen_ids $COUNTER 1
sed -i 's#10000000/" #100/" #' experiment1.sh
python split-nodes.py | bash deploy.sh 1 1
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-ids1-cache100

sleep 180
killall ssh


# ORIGINAL
sed -i 's/sed -i "s\/if rtt/#sed -i "s\/if rtt/' experiment{1,2,3}.sh
sed -i 's/sed -i "s\/^MAX_NUM_TIMEOUTS/#sed -i "s\/^MAX_NUM_TIMEOUTS/' experiment{1,2,3}.sh


gen_ids $COUNTER 1
python split-nodes.py 3 0 | bash deploy.sh 1 1
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 1 1
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 1 1
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.2-churn3-ids1-cache100-original

sleep 180
killall ssh

gen_close_ids $COUNTER
python split-nodes.py 3 0 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2.2-churn3-cache100-node39-original

sleep 180
killall ssh

gen_close_ids $COUNTER
python split-nodes.py 3 0 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp3.2-churn3-cache100-original

sleep 180
killall ssh

gen_ids $COUNTER 2
python split-nodes.py 3 0 | bash deploy.sh 1 2
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 1 2
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 1 2
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.2-churn3-ids2-cache100-original

sleep 180
killall ssh

gen_ids $COUNTER 10
python split-nodes.py 3 0 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.2-churn3-ids10-cache100-original

sleep 180
killall ssh

gen_close_ids $COUNTER
sed -i 's/"39"/"102"/' experiment2.sh
python split-nodes.py 3 0 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2.2-churn3-cache100-node102-original

sleep 180
killall ssh

gen_close_ids $COUNTER
python split-nodes.py 3 0 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp3.2-churn3-cache100-2-original

sleep 180
killall ssh

gen_ids $COUNTER 10
sed -i 's#CLEANUP_COUNTER = 100/"#CLEANUP_COUNTER = 10000000/"#' experiment1.sh
python split-nodes.py 3 0 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.2-churn3-ids10-cache10000000-original


##########################
sleep 180
killall ssh
##########################


gen_ids $COUNTER 1
sed -i 's#CLEANUP_COUNTER = 10000000/"#CLEANUP_COUNTER = 100/"#' experiment1.sh
python split-nodes.py | bash deploy.sh 1 1
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.2-ids1-cache100-original

sleep 180
killall ssh

gen_close_ids $COUNTER
sed -i 's/"102"/"39"/' experiment2.sh
python split-nodes.py | bash deploy.sh 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2.2-cache100-node39-original

sleep 180
killall ssh

gen_close_ids $COUNTER
python split-nodes.py | bash deploy.sh 3
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp3.2-cache100-original

sleep 180
killall ssh

gen_ids $COUNTER 2
python split-nodes.py | bash deploy.sh 1 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.2-ids2-cache100-original

sleep 180
killall ssh

gen_ids $COUNTER 10
python split-nodes.py | bash deploy.sh 1 10
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.2-ids10-cache100-original

sleep 180
killall ssh

gen_close_ids $COUNTER
sed -i 's/"39"/"102"/' experiment2.sh
python split-nodes.py | bash deploy.sh 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2.2-cache100-node102-original

sleep 180
killall ssh

gen_close_ids $COUNTER
python split-nodes.py | bash deploy.sh 3
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp3.2-cache100-2-original

sleep 180
killall ssh

gen_ids $COUNTER 10
sed -i 's#CLEANUP_COUNTER = 100/"#CLEANUP_COUNTER = 10000000/"#' experiment1.sh
python split-nodes.py | bash deploy.sh 1 10
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1.2-ids10-cache10000000-original

sleep 180
killall ssh

gen_ids $COUNTER 2
python split-nodes.py | bash deploy.sh 11 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp11-ids2-cache10000000-original

sleep 180
killall ssh
