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

set +e

execute() {
  tempfile_err=$(mktemp -qt execute.err.XXXXX)
  tempfile_out=$(mktemp -qt execute.out.XXXXX)

  eval "$1" >"$tempfile_out" 2>"$tempfile_err" &
  spinner "$2" "$3" ${4:-12}

  err=$(<"$tempfile_err")
  out=$(<"$tempfile_out")

  if [[ ! -z "$err" ]]; then
    new_line
    label_red "ERROR" "Oh, snap! Something went terribly wrong"
    new_line
    print_text "$err"
    print_text "$out"
    new_line
    print_muted "$ $1"
    new_line

    exitNum=${4:-0}
    if [ "$exitNum" -eq 1 ]; then
      exit 1
    fi
  fi

  if [ $exitCode -eq 124 ]; then
    print_error "Command takes too long to finish, aborted: $1"
  fi

  rm -rf "$tempfile_err" "$tempfile_out"
}
