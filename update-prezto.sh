#!/usr/bin/env bash

origin="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. $origin/_utils.sh
script_setup

title "Update prezto"
version $@ "0.1.0"

__usage="
  Simple script to update prezto.

  Usage:

    1. Run \`bash ${scriptname}\`

  Or put it in your ~/.zprofile:

    alias prezto-upgrade=\"bash ~/.scripts/${scriptname}\"
"

if [ "$1" == "--help" ] || [ "$1" == "help" ]; then
  show_usage "$__usage"
  exit 100
fi

ZPREZTODIR=~/.zprezto

trap 'echo hi' 0 1 2 15

cd "$ZPREZTODIR"

execute "git pull" "" "Updating prezto"

if [[ "$exitCode" -eq 0 ]]; then
  print_success "Finished"
else
  print_error "Failed with code: ${YELLOW}${exitCode}${RESET}"
fi

execute "git submodule update --init --recursive" "" "Updating submodules"

if [[ "$exitCode" -eq 0 ]]; then
  print_success "Finished"
else
  print_error "Failed with code: ${YELLOW}${exitCode}${RESET}"
fi

script_end
