#!/bin/python

# USAGE:
#   python split-nodes.py 3 0 | bash deploy.sh


import sys


if len(sys.argv) == 1:
    SPLIT = False
else:
    SPLIT = True
    MOD = int(sys.argv[1])
    CUR = int(sys.argv[2])


with open('nodes.list', 'r') as nodes:
    for ix, line in enumerate(nodes.readlines()):
        if not SPLIT or ix % MOD == CUR:
            print line.strip()
