. ~/.zsh/formatting.sh
. ~/.zsh/utils.sh
. ~/.zsh/spinner.sh

#
# formatting.sh
#

echo "---"
echo -e "${RED}RED${RESET}"
echo -e "${GREEN}GREEN${RESET}"
echo -e "${YELLOW}YELLOW${RESET}"
echo -e "${BLUE}BLUE${RESET}"
echo ""
echo -e "${DIM}DIM${RESET}"
echo ""
echo -e "${BOLD}BOLD${RESET}"
echo -e "${UNDERLINE}UNDERLINE${RESET}"
echo "---"

#
# utils.sh
#

echo ""

echo "---"
print_info "Just to inform you"
print_question "What is this?"
print_success "Hoooray!"
print_success_muted "Hooo…"
print_warning "Hmm, IMO..."
print_muted "Ssssssh!"
print_error "Oh, snap!"
echo "---"

echo ""

echo "---"
title "Where to start?"
echo_install "Installing this..."
todo "We need to do this next"
inform "We already did this for you!"
step "Your are in 2/23"
echo "---"
label_blue "INFO" "Just to inform you..."
label_green "DONE" "Oh nice run!"
label_red "FAIL" "Oh, snap!"
label_yellow "WARN" "Ahh… no it's okay"
echo "---"

#
# spinner.sh
#

echo ""

echo "---"
execute "sleep 1" "Executing sleep" ""
print_success 'execute "sleep 1" "Executing sleep " ""'

execute "sleep 1" "" "Executing sleep"
print_success 'execute "sleep 1" "" " Executing sleep"'

sleep 1 &
spinner $1 "" "Executing sleep"
print_success 'sleep 1 & spinner $1 "" " Executing sleep"'
echo "---"
