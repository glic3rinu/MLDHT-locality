# Gets the management addresses of all SLICE_ID slivers
#
# USAGE:
#   python get-mgmt-ips.py SLICE_ID
#
# REQUIRES:
#   pip install confine-orm


import sys

from orm.api import Api


if len(sys.argv) != 2:
    raise AttributeError("USAGE: python get-mgmt-ips.py SLICE_ID")

SLICE_ID = sys.argv[1]


def split_len(seq, length):
    """ Returns seq broken in a list of strings of length length """
    return [seq[i:i+length] for i in range(0, len(seq), length)]


def int_to_hex_str(number, digits):
    hex_str = ('%.' + str(digits) + 'x') % number
    err_msg = "Hex representation of %d doesn't fit in %s digits" % (number, digits)
    assert len(hex_str) <= digits, err_msg
    return hex_str


def ipv6_addr(node_id, slice_id, iface_nr=2):
    # Here we assume that mgmt iface.nr value is always 2
    nr = '10' + int_to_hex_str(iface_nr, 2)
    node_id = int_to_hex_str(node_id, 4)
    slice_id = int_to_hex_str(slice_id, 12)
    ipv6_words = MGMT_IPV6_PREFIX.split(':')[:3]
    ipv6_words.extend([node_id, nr])
    ipv6_words.extend(split_len(slice_id, 4))
    return ':'.join(ipv6_words)


controller = Api('https://controller.community-lab.net/api/')
MGMT_IPV6_PREFIX = controller.testbed_params.mgmt_ipv6_prefix
slivers = controller.slivers.retrieve()
slivers.retrieve_related('node', 'slice')
for sliver in slivers.filter(slice__id=249):
    print(ipv6_addr(sliver.node.id, sliver.slice.id))
