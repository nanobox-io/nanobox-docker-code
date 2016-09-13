# source docker helpers
. util/docker.sh

@test "Start Container" {
  start_container
}

@test "Verify hooks installed" {
  # look for a hook that should be there
  run docker exec code bash -c "[ -f /opt/nanobox/hooks/configure ]"

  [ "$status" -eq 0 ]
}

@test "Run update hook" {
  # look for a hook that should be there
  run docker exec code bash -c "/opt/nanobox/hooks/update '{\"component\":{\"uid\":\"web.main\",\"id\":\"9097d0a7-7e02-4be5-bce1-3d7cb1189488\"},\"member\":{\"uid\":\"1\"},\"logvac_host\":\"192.168.0.102\",\"config\":{},\"start\":\"nodeserver.js\"}'"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "Stop Container" {
  stop_container
}
