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

@test "Stop Container" {
  stop_container
}
