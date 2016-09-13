start_container() {

  docker run \
    --name=code \
    -d \
    -e "PATH=$(path)" \
    --privileged \
    --net=nanobox \
    --ip=192.168.0.2 \
    nanobox/code
}

stop_container() {
  docker stop code
  docker rm code
}

path() {
  paths=(
    "/opt/gonano/sbin"
    "/opt/gonano/bin"
    "/opt/gonano/bin"
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/sbin"
    "/usr/bin"
    "/sbin"
    "/bin"
  )

  path=""

  for dir in ${paths[@]}; do
    if [[ "$path" != "" ]]; then
      path="${path}:"
    fi

    path="${path}${dir}"
  done

  echo $path
}
