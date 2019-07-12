#!/usr/bin/env bash

#
# Simple script to stop a docker container by its exposed port
#
# Usage:
#
#   > bash docker-stop-by-port.sh 3306
#
# In .zprofile:
#
#   alias stop="bash ~/.zsh/docker-stop-by-port.sh"
#

. ~/.zsh/_utils.sh

script_setup
port=$1

title "Stop docker container by port: $port"

if [ -z $port ]; then
  print_warning "Please specify a port to a running docker container!"
  exit 1
fi

port_is_number_regex='^[0-9]+$'
if ! [[ $port =~ $port_is_number_regex ]]; then
  print_error "Port can only be of type number!"
  exit 1
fi

num_results=0
no_results=0
SECONDS=0

for id in $(docker ps -q); do
  ((num_results += 1))
  if [[ $(docker port "${id}") == *"${port}"* ]]; then
    execute "docker stop $id" "" "Stopping container ${GREEN}${id}${RESET}"

    if [ $exitCode -eq 0 ]; then
      print_success "Finished in ${SECONDS}s"
      exit 0
    else
      print_error "Failed with code: ${YELLOW}${exitCode}${RESET} in ${SECONDS}s"
      exit 1
    fi
  else
    ((no_results += 1))
  fi
done

if [ $num_results -eq $no_results ]; then
  print_info "No running container found with port ${YELLOW}${port}${RESET}"
fi

step "Done after ${SECONDS}s"
