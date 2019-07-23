#!/usr/bin/env bash

#
# Simple script to stop a docker container by its exposed port
#
# Usage:
#
#   > bash docker-stop-by-port.sh 3306 443
#   > bash docker-stop-by-port.sh all
#
# In .zprofile:
#
#   alias stop="bash ~/.zsh/docker-stop-by-port.sh"
#

. ~/.zsh/_utils.sh

script_setup
ports=$@

title "Stop docker container by ports: ${ports}"

# check if ports are passed
if [ -z "${ports}" ]; then
  print_warning "Please specify ports to running docker containers!"
  exit 1
fi

# stop all containers and exit
if [ "$1" == "all" ]; then
  execute "docker stop $(docker ps -q | tr '\n' ' ')" "" "Stopping all running containers!"
  # execute "docker ps -q" "" "Stopping all running containers!"

  if [ $exitCode -eq 0 ]; then
    print_success "Successfully stopped all containers in ${SECONDS}s"
    exit 0
  else
    print_error "Failed with code: ${YELLOW}${exitCode}${RESET} (${SECONDS}s)"
    exit 1
  fi
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

  for port in $ports; do
    ((num_results += 1))

    if [[ $(docker port "${id}") == *"${port}"* ]]; then
      execute "docker stop ${id}" "" "Stopping container ${container_sign}"

      if [ $exitCode -eq 0 ]; then
        print_success "Successfully stopped ${container_sign} (${SECONDS}s)"
      else
        print_error "Failed with code: ${YELLOW}${exitCode}${RESET} (${SECONDS}s)"
      fi
    else
      ((no_results += 1))
    fi
  done

  if [ $num_results -eq $no_results ]; then
    print_info "No port matches port of ${container_sign} (${container_port})"
  fi

  num_results=0
  no_results=0

done

step "Done after ${SECONDS}s"
