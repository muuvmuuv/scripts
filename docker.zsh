#!/bin/zsh

setopt extendedglob
setopt kshglob

__usage="
    Tool to simply some docker stuff and stop containers easier.

    Options:

        duck [command] <port>

        list        Show a list of all running containers with their public ports
        stop        Stop container by port, name or ID
        all         Stop all running containers
        help        Show this message

    Usage:

        > duck 3306 443
        > duck all
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
        echo " ${container_name}:${id} \e[2m(${container_port})\e[0m"
    done
}

function stop_all {
    echo "\nRunning containers:\n"
    containers=( ${(s/ /)container_running} )
    for c in $containers; do echo "- $c"; done;
    echo "\nStopping...\n"
    docker stop $(echo ${containers})
}

function stop_by_port {
    ports=( ${(s/ /)args} )
    ports=( ${ports[@][2, -1]} )

    for port in $ports; do
        echo "\n\e[1;96m>>> Checking port $port:\e[0m"

        for id in $(docker ps -q); do
            container_name=$(get_name $id)
            container_port=$(get_port $id)

            echo -e "\n\e[2m${container_name}:${id} (${container_port})\e[0m"

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
    stop)
        stop_by_port
        ;;
    *)
        echo "${__usage}"
        exit
        ;;
esac
