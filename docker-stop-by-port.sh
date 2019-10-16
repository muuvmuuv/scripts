#!/usr/bin/env bash

origin="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. $origin/_utils.sh
script_setup

title "Stop docker container by ports"
version $@ "0.3.0"

__usage="
  Simple script to stop a docker container by its exposed port

  Usage:

    > bash ${scriptname} 3306 443
    > bash ${scriptname} all

  Or put it in your ~/.zprofile:

    alias stop=\"bash ~/.zsh/${scriptname}\"
"

if [ "$#" -eq 0 ] || [ "$1" == "--help" ] || [ "$1" == "help" ]; then
  show_usage "$__usage"
  exit 100
fi

ports=$@

# check if ports are passed
if [ -z "${ports}" ]; then
  print_warning "Please specify ports to running docker containers!"
  exit 1
fi

running_containers=$(docker ps -q | tr '\n' ' ')
if [ -z "$running_containers" ]; then
  print_info "No containers running at the moment"
  exit 0
fi

# list all running containers
if [ "$1" == "list" ]; then
  count=0
  for id in $(docker ps -q); do
    ((count += 1))
    container_name=$(docker ps -f "id=${id}" --format "{{.Names}}")
    container_port=$(docker ps -f "id=${id}" --format "{{.Ports}}")
    container_sign="${GREEN}${container_name}:${id}${RESET}"
    print_custom "$count" "$container_sign (${container_port})"
  done
  exit 0
fi

# stop all containers and exit
if [ "$1" == "all" ]; then
  execute "docker stop $running_containers" "" "Stopping all running containers"
  handle_exit "Successfully stopped all containers"
  exit 0
fi

# check if all ports are valid ports
port_is_number_regex='^[0-9]+$'
for port in $ports; do
  if ! [[ $port =~ $port_is_number_regex ]]; then
    print_error "Port can only be of type number: ${YELLOW}${port}${RESET}"
    exit 1
  fi
done

num_results=0
no_results=0

# loop all running(!) containers
for id in $(docker ps -q); do
  container_name=$(docker ps -f "id=${id}" --format "{{.Names}}")
  container_port=$(docker ps -f "id=${id}" --format "{{.Ports}}")
  container_sign="${GREEN}${container_name}:${id}${RESET}"

  headline "Checking $container_sign (${container_port})"

  for port in $ports; do
    ((num_results += 1))

    execute "if [[ \"$container_port\" == *${port}* ]]; then exit 0; else exit 1; fi" "" "Checking port $port"

    if [[ "$exitCode" -eq 0 ]]; then
      execute "docker stop ${id}" "" "Stopping container with port $port..."
      handle_exit "Successfully stopped container"
      break
    else
      print_error "$port does not match this container"
      ((no_results += 1))
    fi
  done

  if [ $num_results -eq $no_results ]; then
    new_line
    print_text "Skipped"
  fi

  num_results=0
  no_results=0

  new_line
done
