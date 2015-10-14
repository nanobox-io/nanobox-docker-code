VERSION=$1
echo running tests for code
UUID=$(cat /proc/sys/kernel/random/uuid)
PAYLOAD='{"platform":"local","boxfile":{"extensions":{},"locale":"en_US.UTF-8"},"uid":"'$UUID'","logtap_host":"127.0.0.1"}'
echo boxfile: "$PAYLOAD"

pass "unable to start the container" docker run --privileged=true -d --name $UUID nanobox/code
defer docker kill $UUID

# we should be able to run the basic configure hook
pass "unable to run the configure hook for code" docker exec $UUID /opt/bin/default-configure "$PAYLOAD"

# now we just need to verify that changes were atually made correctly.