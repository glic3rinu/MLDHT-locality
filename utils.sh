function gen_ids() {
    # ID[$IDS_PER_NODE*$COUNTER] = Node info hashes
    echo "
import identifier
for i in range($2*$1+1):
    print(repr(identifier.RandomId()))

" | python > /tmp/infohashes.list
}


function gen_close_ids() {
    # ID(0) = info_hash
    # ID(>0) = Node ID
    echo "
import identifier
base_ident = repr(identifier.RandomId())
for i in range($1+2):
    ident = repr(identifier.RandomId())
    ident = base_ident[:30] + ident[30:]
    print(ident)

" | python > /tmp/infohashes.list
}
