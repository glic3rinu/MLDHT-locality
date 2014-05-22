python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 200

python split-nodes.py 3 0 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp1-ids1-cache100

sleep 300

python split-nodes.py 3 0 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp2-cache100-node39

sleep 300

python split-nodes.py 3 0 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp3-cache100

sleep 300

sed -i "s/IDS_PER_NODE=1/IDS_PER_NODE=2/" deploy.sh
python split-nodes.py 3 0 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp1-ids2-cache100

sleep 300

sed -i "s/IDS_PER_NODE=2/IDS_PER_NODE=10/" deploy.sh
python split-nodes.py 3 0 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp1-ids10-cache100

sleep 300

sed -i 's/"39"/"102"/' experiment2.sh
python split-nodes.py 3 0 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 2
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp2-cache100-node102

sleep 300

python split-nodes.py 3 0 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh 3
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp3-cache100-2

sleep 300

sed -i 's#100/" #10000000/"#' experiment.sh
python split-nodes.py 3 0 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 60
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-exp1-ids10-cache10000000
