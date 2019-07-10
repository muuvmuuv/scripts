#!/usr/bin/env bash

# Utility Functions

_kill_all_subprocesses() {
  local i=""
  for i in $(jobs -p); do
    kill "$i"
    wait "$i" &>/dev/null
  done
}

_set_trap() {
  trap -p "$1" | grep "$2" &>/dev/null ||
    trap '$2' "$1"
}

repeat() {
  start=1
  end=$2
  for ((i = $start; i <= $end; i++)); do
    echo -n "${1}"
  done
}

# Print Functions

print_info() {
  echo -e "${INDENT}[${BLUE}i${RESET}] $1"
}

print_question() {
  echo -e "${INDENT}[${YELLOW}?${RESET}] $1"
}

print_success() {
  echo -e "${INDENT}[${GREEN}✓${RESET}] $1"
}

print_success_muted() {
  echo -e "${INDENT}[${DIM}✓${RESET}] $1"
}

print_muted() {
  echo -e "${INDENT}${DIM}$1${RESET}"
}

print_warning() {
  echo -e "${INDENT}[${YELLOW}${BLINK}!${RESET}] $1"
}

print_error() {
  echo -e "${INDENT}[${RED}𝘅${RESET}] $1"
}

label_blue() {
  echo -e "${INDENT}${BG_BLUE}${WHITE} $1 ${RESET} ${BLUE}$2${RESET}"
}

label_green() {
  echo -e "${INDENT}${BG_GREEN} $1 ${RESET} ${GREEN}$2${RESET}"
}

label_red() {
  echo -e "${INDENT}${BG_RED} $1 ${RESET} ${RED}$2${RESET}"
}

label_yellow() {
  echo -e "${INDENT}${BG_YELLOW} $1 ${RESET} ${YELLOW}$2${RESET}"
}

# Text utilities

title() {
  echo ""
  echo -e "${INDENT}⚘  ${BOLD}$1${RESET}"
  underline=$(repeat "─" 60)
  echo -e "${INDENT}└${underline}○"
  echo ""
}

echo_install() {
  echo -e "${INDENT}[↓] $1"
}

todo() {
  echo -e "${INDENT}[ ] $1"
}

step() {
  echo ""
  echo -e "${INDENT}${DOT} ${UNDERLINE}$1${RESET}\n"
}
