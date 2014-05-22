import glob
import sys

import matplotlib.pyplot as plt
import numpy as np
from pylab import plot,show


FILES = '*'
if len(sys.argv) == 2:
    FILES = sys.argv[1]


for result in glob.glob('results/' + FILES):
    initial_time = None
    with open(result, 'r') as results:
        nodes = {}
        times = {}
        for line in results.readlines():
            line = line.split()
            if len(line) == 2:
                node, time = line
                hops, latencies = None, None
            elif len(line) == 3:
                node, time, latencies = line
                latencies = [float(latency) for latency in latencies.split(',')]
                hops = None
            elif len(line) == 4:
                node, time, hops, latencies = line
                hops = [int(hop) for hop in hops.split(',')]
                latencies = [float(latency) for latency in latencies.split(',')]
            else:
                continue
            
            nodes.setdefault(node, [])
            time = int(time.split('.')[0])
            nodes[node].append((time, hops, latencies))
            
            key = int(str(time)[:-2] + '00')
            times.setdefault(key, [])
            times[key].append((time, hops, latencies))
        
        plt.figure(1)
        plt.title(result)
        for node, values in nodes.iteritems():
            node_hops = []
            node_latencies = []
            node_times = []
            for value in values:
                time, hops, latencies = value
                node_times.append(time)
                if hops:
                    hops = sum(hops)/len(hops)
                node_hops.append(hops)
                if latencies:
                    latencies = sum(latencies)/len(latencies)
                node_latencies.append(latencies)
            plt.subplot(311)
            plt.title(result + " Hops")
            plt.plot(node_times, node_hops)
            plt.subplot(312)
            plt.title(result + " Latency")
            plt.plot(node_times, node_latencies)
        
        t_result, h_result, l_result = [], [], []
        for time, values in times.iteritems():
            time_hops = []
            time_latencies = []
            for value in values:
                time, hops, latencies = value
                if hops:
                    hops = sum(hops)/len(hops)
                    time_hops.append(hops)
                if latencies:
                    latencies = sum(latencies)/len(latencies)
                    time_latencies.append(latencies)
            if time_hops:
                t_result.append(time)
                h_result.append(sum(time_hops)/len(time_hops) if time_hops else None)
                l_result.append(sum(time_latencies)/len(time_latencies)/20 if time_latencies else None)
        
        xi = np.array(t_result)
        xi = np.array(t_result)
        A = np.array([ xi, np.ones(len(xi))])
        y = np.array(h_result, dtype=np.float)
        y = np.ma.masked_array(y, np.isnan(y))
        w = np.linalg.lstsq(A.T,y)[0]
        line = w[0]*xi+w[1]
        
        plt.subplot(313)
        plt.title(result + " Slotted")
        plt.plot(t_result, h_result, 'g^', t_result, l_result, 'bs', t_result, line,'g-')
        plt.show()
#        plt.savefig(result + '.png')
