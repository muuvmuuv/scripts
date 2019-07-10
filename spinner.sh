#
# @@@@@@ Spinner @@@@@@
#
# Display a spinner for long running commands. It is also compatible
# for loops.
#
# Usage:
#
#   execute [command] [text_before] [text_after]
#   spinner [pid] [text_before] [text_after]
#
# Example:
#
#   (mkdir test) &>/dev/null &
#     spinner "" "Creating test"
#
# Output:
#
#   Spinner [=== ]
#   Spinner [=== ] is running
#   [=== ] is running
#

. ~/.zsh/formatting.sh
. ~/.zsh/utils.sh

spinner() {
  local pid=$!
  exitCode=0

  _set_trap "KILL" "_kill_all_subprocesses"

  # PARTS=("[/]" "[-]" "[\]" "[|]")
  PARTS=("[⠋]" "[⠙]" "[⠹]" "[⠸]" "[⠼]" "[⠴]" "[⠦]" "[⠧]" "[⠇]" "[⠏]")
  # PARTS=("[    ]" "[=   ]" "[==  ]" "[=== ]" "[ ===]" "[  ==]" "[   =]" "[    ]" "[   =]" "[  ==]" "[ ===]" "[====]" "[=== ]" "[==  ]" "[=   ]")
  PART_LENGTH=6

  INPUT_BEFORE="$1"
  INPUT_BEFORE_LENGTH="${#INPUT_BEFORE}"
  INPUT_AFTER="$2"
  INPUT_AFTER_LENGTH="${#INPUT_AFTER}"

  BACKSPACES_LENGTH=$(($INPUT_BEFORE_LENGTH + 1 + $PART_LENGTH + 1 + $INPUT_AFTER_LENGTH))
  BACKSPACES=$(repeat "\b" ${BACKSPACES_LENGTH})
  SPACES=$(repeat " " ${BACKSPACES_LENGTH})

  BEFORE="${INDENT}"
  if [[ ! -z "$INPUT_BEFORE" ]]; then
    BEFORE="${INDENT}${INPUT_BEFORE} "
  fi
  AFTER=""
  if [[ ! -z "$INPUT_AFTER" ]]; then
    AFTER=" ${INPUT_AFTER}"
  fi

  printf "${BEFORE}${PARTS[0]}${AFTER}"

  INDEX=1
  MAX=$((${#PARTS[@]} - 1))
  while kill -0 "$pid" &>/dev/null; do
    printf "${BACKSPACES}${BEFORE}%s${AFTER}" "${PARTS[INDEX]}"
    ((INDEX += 1))
    if [ "$INDEX" -eq "$MAX" ]; then
      INDEX=0 # to start the parts from beginning
    fi
    sleep 0.1
  done

  wait $pid &>/dev/null
  exitCode=$?

  printf "\r${SPACES}\r"

  return $exitCode
}

execute() {
  ($1) &>/dev/null &
  spinner "$2" "$3"
}
