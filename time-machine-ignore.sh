#!/usr/bin/env bash

#
# Simple script to exclude folders and files from Time Machine backups
# from a file.
#
# Usage:
#
#   1. Create a file in your root folder: ~/.tmignore
#   2. On each line put a absolute file or directory you want to exclude
#   3. Run `bash time-machine-ignore.sh`
#
# In .zprofile:
#
#   alias stop="bash ~/.zsh/time-machine-ignore.sh"
#

. ~/.zsh/formatting.sh
. ~/.zsh/spinner.sh

filePath=~/.tmignore
SECONDS=0

title "Exclude files and directories from Time Machine"

if [[ ! -e "$filePath" ]]; then
  print_warning "Could not find \`.tmignore\` in your root!"
  exit 1
fi

while IFS= read -r path || [[ -n "$path" ]]; do
  # replace tilde with home absolute path
  path=${path/\~/$HOME}

  # this path is commented out
  if [[ $path == \;* ]]; then
    continue
  fi

  # if the file or directory does not exist
  if [[ ! -e "$path" ]] && [[ ! -d "$path" ]]; then
    print_warning "Could not find $path"
    continue
  fi

  # get file or directory size
  # TODO: https://stackoverflow.com/questions/56971930/run-a-function-while-background-task-is-running-and-return-stdout-to-variable
  # sizeondisk=$(du -hs "$path" | cut -f1) &
  # spinner "" "Getting file size for $path..."

  # if the file or directory is already excluded
  if tmutil isexcluded "$path" | grep -q '\[Excluded\]'; then
    print_info "Already excluded ${UNDERLINE}$path${RESET} ($sizeondisk)"
    continue
  fi

  # exclude the file or directory from Time Machine backups
  execute "tmutil addexclusion $path" " " "Excluding $path ($sizeondisk)"

  if [[ "$exitCode" -eq 0 ]]; then
    print_success "Excluded $path ($sizeondisk)"
  else
    print_error "Failed with code: ${YELLOW}${exitCode}${RESET}"
  fi
done <$filePath

echo -e "\n  ${GREEN}Done${RESET} after ${SECONDS}s"
