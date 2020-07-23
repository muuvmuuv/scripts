#!/bin/zsh

setopt extendedglob
setopt kshglob

#
# Docker stop
#
# Stop a docker container by its port, name or just all.
#

__usage="
    Stop a docker container by its port, name or just all.

    Options:

        dstop [command] <port>

        list        Show a list of all running containers
        all         Stop all running containers
        help        Show this message

    Usage:

        > dstop 3306 443
        > dstop all
"

args=$@

container_running=$(docker ps -q | tr '\n' ' ')

if [ -z $container_running ]; then
  echo "\nNo containers running at the moment"
  exit 0
fi

function get_name {
    readonly id=$1

    echo $(docker ps -f "id=${id}" --format "{{.Names}}")
}

function get_port {
    readonly id=$1

    echo $(docker ps -f "id=${id}" --format "{{.Ports}}")
}

function list_active {
    echo " "
    for id in $(docker ps -q); do
        container_name=$(get_name $id)
        container_port=$(get_port $id)
        echo "${container_name}:${id} (${container_port})"
    done
}

function stop_all {
    echo "\nStopping all.."
    containers=( ${(s/ /)container_running} )
    for c in $containers; do echo "- $c"; done;
    echo " "
    docker stop ${container_running}
}

function stop_by_port {
    ports=( ${(s/ /)args} )

    for port in $ports; do
        echo "\n>>> Checking port $port:"

        for id in $(docker ps -q); do
            container_name=$(get_name $id)
            container_port=$(get_port $id)

            echo "\n${container_name}:${id} (${container_port})"

            if [[ $container_port == *${port}* ]]; then
                echo "Stopping container..."
                docker stop ${id}
                break
            else
                echo "Does not match, skipping..."
            fi
        done
    done
}

case "$1" in
    list)
        list_active
        ;;
    all)
        stop_all
        ;;
    [0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9][0-9][0-9])
        stop_by_port
        ;;
    *)
        echo "${__usage}"
        exit
        ;;
esac
