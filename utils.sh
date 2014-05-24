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


function get_two_bucked_ids() {
    TOTAL=$(($1+4))
    gen_close_ids $TOTAL
    ONE=$(cat /tmp/infohashes.list)
    gen_close_ids $TOTAL
    TWO=$(cat /tmp/infohashes.list)
    for i in $(seq $TOTAL); do
        if [[ $(($i%2)) -eq 0 ]]; then
            echo -e "$ONE" | sed -n -e ${i}p
        else
            echo -e "$TWO" | sed -n -e ${i}p
        fi
    done > /tmp/infohashes.list
}
