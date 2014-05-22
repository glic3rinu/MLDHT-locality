source utils.sh

COUNTER=$(wc -l nodes.list|awk {'print $1'})

python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 200
gen_ids $COUNTER 1
python split-nodes.py 3 0 | bash deploy.sh 1 1
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 1 1
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 1 1
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-churn3-ids1-cache100

sleep 300
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
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp2-cache100-node39

sleep 300
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
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp3-cache100

sleep 300
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
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-churn3-ids2-cache100

sleep 300
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
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-churn3-ids10-cache100

sleep 300
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
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp2-cache100-node102

sleep 300
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
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp3-cache100-2

sleep 300
killall ssh

gen_ids $COUNTER 10
sed -i 's#100/" #10000000/"#' experiment1.sh
python split-nodes.py 3 0 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 1 10
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment1.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-churn3-ids10-cache10000000


##########################
sleep 300
killall ssh
##########################


gen_ids $COUNTER 1
sed -i 's#10000000/" #100/"#' experiment1.sh
python split-nodes.py | bash deploy.sh 1 1
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-ids1-cache100

sleep 300
killall ssh

gen_close_ids $COUNTER
sed -i 's/"102"/"39"/' experiment2.sh
python split-nodes.py | bash deploy.sh 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2-cache100-node39

sleep 300
killall ssh

gen_close_ids $COUNTER
python split-nodes.py | bash deploy.sh 3
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp3-cache100

sleep 300
killall ssh

gen_ids $COUNTER 2
python split-nodes.py | bash deploy.sh 1 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-ids2-cache100

sleep 300
killall ssh

gen_ids $COUNTER 10
python split-nodes.py | bash deploy.sh 1 10
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-ids10-cache100

sleep 300
killall ssh

gen_close_ids $COUNTER
sed -i 's/"39"/"102"/' experiment2.sh
python split-nodes.py | bash deploy.sh 2
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp2-cache100-node102

sleep 300
killall ssh

gen_close_ids $COUNTER
python split-nodes.py | bash deploy.sh 3
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp3-cache100-2

sleep 300
killall ssh

gen_ids $COUNTER 10
sed -i 's#100/" #10000000/"#' experiment1.sh
python split-nodes.py | bash deploy.sh 1 10
sleep $((62*60))
python split-nodes.py | bash execute.sh "bash collect.sh" > results/exp1-ids10-cache10000000
