#!/usr/bin/env bash

#
# Executes a command and shows a spinner while doing so.
#
# Usage:
#
#   execute [command] [text_before] [text_after] [exit_or_continue]
#
# Example:
#
#   execute "sleep .5" "" "Sleeping…" 1
#

execute() {
  tempfile=$(mktemp -qt execute.XXXXX)
  { eval "$1"; } 2>"$tempfile" &
  spinner "$2" "$3" ${4:-12}

  error=$(<"$tempfile")
  if [[ ! -z "$error" ]]; then
    echo ""
    label_red "ERROR" "Oh, snap! Something went terribly wrong"
    echo ""
    echo "${INDENT}$error"
    print_muted "$ $1"
    echo ""

    local exitNum=${4:-0}
    if [ "$exitNum" -eq 1 ]; then
      exit 1
    fi
  fi

  if [ $exitCode -eq 124 ]; then
    print_error "Command takes too long to finish, aborted: $1"
  fi
}
