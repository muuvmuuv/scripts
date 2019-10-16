#!/usr/bin/env bash

origin="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. $origin/_utils.sh
script_setup

#
# text.sh
#

title "text.sh"

print_text "${RED}RED${RESET}"
print_text "${GREEN}GREEN${RESET}"
print_text "${YELLOW}YELLOW${RESET}"
print_text "${BLUE}BLUE${RESET}"
print_text "${WHITE}BLUE${RESET}"

new_line

print_text "${BG_RED}RED${RESET}"
print_text "${BG_GREEN}GREEN${RESET}"
print_text "${BG_YELLOW}YELLOW${RESET}"
print_text "${BG_BLUE}BLUE${RESET}"
print_text "${BG_WHITE}BLUE${RESET}"

new_line

print_text "${DIM}DIM${RESET}"

new_line

print_text "${BOLD}BOLD${RESET}"
print_text "${UNDERLINE}UNDERLINE${RESET}"
print_text "${BLINK}BLINK${RESET}"

new_line

print_text "${INDENT}INDENT${RESET}"
print_text "${DOT}DOT${RESET}"

step "1/5"

#
# functions.sh
#

title "functions.sh"

# fileSize
headline 'fileSize'
path=~/.config
print_text "File size for $path:"
sizeondisk=$(fileSize "$path")
print_text "$sizeondisk"

new_line

# repeat
headline 'repeat'
char=$(repeat "\\/" 20)
print_text "Repeat '\/' 20 times: ${char}"

new_line

# strip_ansi
headline 'strip_ansi'
rainbow="${BLUE}R${GREEN}${UNDERLINE}A${YELLOW}I${RESET}${BLUE}N${RED}B${YELLOW}${BLINK}O${GREEN}W${RESET}"
rainbow_nocolor=$(strip_ansi "$rainbow")
print_text "$rainbow"
print_text "$rainbow_nocolor"

new_line

# center_text
headline 'center_text'
centered_text=$(center_text "♱" 20 " I'm soo centered ")
print_text "$centered_text"

step "2/5"

#
# components.sh
#

title "components.sh"

# basic text
headline 'Basic text'
print_text "print_text"
print_muted "print_muted"
print_info "print_info"
print_question "print_question"
print_success "print_success"
print_success_muted "print_success_muted"
print_warning "print_warning"
print_error "print_error"

new_line

# labels
headline 'Labels'
label_blue "GREEN" "label_blue"
label_green "YELLOW" "label_green"
label_red "BLUE" "label_red"
label_yellow "RED" "label_yellow"

new_line

# others
headline 'Others'
print_text "title – to print those big fance block titles"
print_text "headline – to print some section headlines"
echo_install "echo_install"
todo "todo"
print_text "step – ↓ prints this ↓"

step "3/5"

#
# execute.sh
#

title "execute.sh"

# just executes with text before
execute "sleep 1" "Executing sleep" ""
print_success 'execute "sleep 1" "Executing sleep " ""'

# just executes with text after
execute "sleep 1" "" "Executing sleep"
print_success 'execute "sleep 1" "" " Executing sleep"'

# fail because command does not exist
execute "imagination" "" "Failed executing imagination: command not found"
print_error 'execute "imagination" "" "Failed executing imagination: command not found"'

# fail because command takes to long
execute "sleep 10" "" "Failed executing sleep: takes too long" 2

step "4/5"

#
# spinner.sh
#

title "spinner.sh"

# show spinner
sleep 1 &
spinner "" "Finish after a sleep"
print_success 'sleep 1 & spinner "" "Finish after a sleep"'

# fail because it takes to long
sleep 10 &
spinner "" "Failing while sleeping too long" 2
print_error 'sleep 100 & spinner "" "Failing while sleeping too long" 2'

step "5/5"

script_end
