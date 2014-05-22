python split-nodes.py 3 0 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 1 | bash deploy.sh
sleep $((20*60))
python split-nodes.py 3 2 | bash deploy.sh
sleep $((20*60))
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 10
python split-nodes.py | bash execute.sh "pkill -f client.py; pkill -f experiment.sh; pkill -f experiment2.sh; pkill -f experiment3.sh"
sleep 100
python split-nodes.py | bash execute.sh "bash collect.sh" > results/churn3-ids1-cache10000000
