#!/usr/bin/env bash

WIDTH=70
INDENT='  '

# ---------------------------------------------

new_line() {
  echo ""
}

print_text() {
  echo -e "${INDENT}$1"
}

print_info() {
  print_text "[${BLUE}i${RESET}] $1"
}

print_question() {
  print_text "[${YELLOW}?${RESET}] $1"
}

print_success() {
  print_text "[${GREEN}✓${RESET}] $1"
}

print_success_muted() {
  print_text "[${DIM}✓${RESET}] $1"
}

print_muted() {
  print_text "${DIM}$1${RESET}"
}

print_warning() {
  print_text "[${YELLOW}${BLINK}!${RESET}] $1"
}

print_error() {
  print_text "[${RED}𝘅${RESET}] $1"
}

label_blue() {
  print_text "${BG_BLUE}${WHITE} $1 ${RESET} ${BLUE}$2${RESET}"
}

label_green() {
  print_text "${BG_GREEN} $1 ${RESET} ${GREEN}$2${RESET}"
}

label_red() {
  print_text "${BG_RED} $1 ${RESET} ${RED}$2${RESET}"
}

label_yellow() {
  print_text "${BG_YELLOW} $1 ${RESET} ${YELLOW}$2${RESET}"
}

# ---------------------------------------------

title() {
  new_line
  print_text "⚘  ${BOLD}$1${RESET}"
  underline=$(repeat "─" $WIDTH)
  print_text "└${underline}○"
  new_line
}

headline() {
  print_text "${BOLD}${UNDERLINE}$1${RESET}"
  new_line
}

echo_install() {
  print_text "[↓] $1"
}

todo() {
  print_text "[ ] $1"
}

step() {
  new_line
  print_text "${DOT} ${DIM}$1${RESET}\n"
}
