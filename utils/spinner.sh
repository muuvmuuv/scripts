#!/usr/bin/env bash

#
# Display a spinner for long running commands.
#
# Usage:
#
#   spinner [pid] [text_before] [text_after] [max_execution_time]
#
# Example:
#
#   (sleep .5) &
#     spinner "" "Sleeping…"
#
# Output:
#
#   Spinner [=== ]
#   Spinner [=== ] is running
#   [=== ] is running
#

spinner() {
  local pid=$!
  timeout=${3:-2}
  killcode=0
  exitCode=0

  trap "kill $pid &>/dev/null" EXIT

  # PARTS=("[/]" "[-]" "[\]" "[|]")
  PARTS=("[⠋]" "[⠙]" "[⠹]" "[⠸]" "[⠼]" "[⠴]" "[⠦]" "[⠧]" "[⠇]" "[⠏]")
  # PARTS=("[    ]" "[=   ]" "[==  ]" "[=== ]" "[ ===]" "[  ==]" "[   =]" "[    ]" "[   =]" "[  ==]" "[ ===]" "[====]" "[=== ]" "[==  ]" "[=   ]")

  PARTS_LENGTH=$((${#PARTS[@]} - 1))
  PART_LENGTH=3

  INPUT_BEFORE="$1"
  BEFORE="${INDENT}"
  if [[ ! -z "$INPUT_BEFORE" ]]; then
    BEFORE="${INDENT}${INPUT_BEFORE} "
  fi
  BEFORE_LENGTH="${#BEFORE}"

  INPUT_AFTER="$2"
  AFTER=""
  if [[ ! -z "$INPUT_AFTER" ]]; then
    AFTER=" ${INPUT_AFTER}"
  fi
  AFTER_LENGTH="${#AFTER}"

  TIME_LENGTH=$((${#timeout} + 3))
  BACKSPACES_LENGTH=$(($BEFORE_LENGTH + 1 + $PART_LENGTH + 1 + $AFTER_LENGTH + $TIME_LENGTH))
  BACKSPACES=$(repeat "\b" ${BACKSPACES_LENGTH})
  SPACES=$(repeat " " ${BACKSPACES_LENGTH})

  # provide more space so that the text doesn't reach the bottom
  # BUG: single line is fine but when it reaches the bottom it escalates
  # printf "\n\n"
  # tput cuu 2
  # tput sc

  # print first paint and clear line
  printf "${BEFORE}${PARTS[0]}${AFTER}" >&2

  INDEX=1
  START=$(date +%s)

  while kill -0 "$pid" &>/dev/null; do

    # max execution time calculation
    NOW=$(date +%s)
    ELAPSED_TIME=$(($NOW - $START))
    if [ "$ELAPSED_TIME" -eq "$timeout" ]; then
      killcode=124
      kill $pid
      break
    fi

    # print the loading message and indicator
    printf "${BACKSPACES}${BEFORE}%s${AFTER} (${ELAPSED_TIME}s)" "${PARTS[INDEX]}" >&2

    # set next indicator index
    ((INDEX += 1))
    if [ "$INDEX" -eq "$PARTS_LENGTH" ]; then
      INDEX=0 # to start the parts from beginning
    fi

    # don't be too fast
    sleep 0.1

  done

  wait $pid &>/dev/null
  trap - EXIT

  # clear line
  printf "\r${SPACES}\r" >&2
  # tput rc

  # set returning exit code
  if [ "$killcode" -eq 124 ]; then
    exitCode=124 # timeout
  else
    exitCode=$?
  fi

  return $exitCode
}
