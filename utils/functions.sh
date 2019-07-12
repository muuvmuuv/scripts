#!/usr/bin/env bash

script_setup() {
  clear        # clear the terminal screen
  tput cup 0 2 # start on line X collumn Y
  tput civis   # hide the users cursor

  trap script_end EXIT
}
script_end() {
  echo ""
  tput cnorm # show the users cursor
}

#
# sizeondisk=$(fileSize "~/.zsh")
#
fileSize() {
  local path="$1"
  tempfile=$(mktemp -qt filesize.XXXXX)
  { du -hs "$path" | cut -f1; } >"$tempfile" &
  spinner "" "Getting file/dir size for $path"
  sizeondisk=$(<"$tempfile")
  sizeondisk="${sizeondisk// /}"
  rm -rf "$tempfile"
  if [ $exitCode -eq 124 ]; then
    echo -n "⚠ "
  else
    echo -n "$sizeondisk"
  fi
}

#
# spaces=$(repeat " " 14)
#
repeat() {
  start=1
  end=$2
  for ((i = $start; i <= $end; i++)); do
    echo -n "${1}"
  done
}

#
# strip_ansi "\033[31mTEXT\033[0m"
#
strip_ansi() {
  shopt -s extglob
  echo -n "${1//'\033'\[+([0-9;])m/}"
}

#
# center_text "─" 20 "This is text"
#
center_text() {
  text="$3"
  plain_text=$(strip_ansi "$text")
  text_length="${#plain_text}"
  before_after=$(repeat "$1" $2)
  echo -n "${before_after}$text${before_after}"
}
