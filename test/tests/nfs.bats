# source docker helpers
. util/docker.sh

@test "Start Container" {
  start_container
}

@test "Verify nfs client installed" {
  # ensure portal executable exists
  run docker exec code bash -c "[ -f /sbin/mount.nfs ]"

  [ "$status" -eq 0 ]
}

@test "Stop Container" {
  stop_container
}
