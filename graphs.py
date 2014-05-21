import glob

import matplotlib.pyplot as plt


for result in glob.glob('results/*'):
    with open(result, 'r') as results:
        nodes = {}
        for line in results.readlines():
            line = line.split()
            if len(line) == 2:
                node, time = line
                hops, latencies = None, None
            elif len(line) == 3:
                node, time, latencies = line
                hops = None
            elif len(line) == 4:
                node, time, hops, latencies = line
            else:
                continue
            nodes.setdefault(node, [])
            nodes[node].append((time, hops, latencies))
        
        plt.figure(1)
        plt.title(result)
        for node, values in nodes.iteritems():
            node_hops = []
            node_latencies = []
            node_times = []
            for value in values:
                time, hops, latencies = value
                time = int(time.split('.')[0])
                node_times.append(time)
                if hops:
                    hops = [int(hop) for hop in hops.split(',')]
                    hops = sum(hops)/len(hops)
                node_hops.append(hops)
                if latencies:
                    latencies = [float(latency) for latency in latencies.split(',')]
                    latencies = sum(latencies)/len(latencies)
                node_latencies.append(latencies)
            plt.subplot(211)
            plt.title(result + " Hops")
            plt.plot(node_times, node_hops)
            plt.subplot(212)
            plt.title(result + " Latency")
            plt.plot(node_times, node_latencies)
        plt.show()
#        plt.savefig(result + '.png')
