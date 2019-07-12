#!/usr/bin/env bash

#
# Simple script to exclude folders and files from Time Machine backups
# from a file. This is good for automating the exclution of files and
# folders.
#
# Usage:
#
#   1. Create a file in your root folder: ~/.tmexclude
#   2. On each line put a absolute file or directory you want to exclude
#   3. Run `bash time-machine-ignore.sh`
#
# In .zprofile:
#
#   alias stop="bash ~/.zsh/time-machine-ignore.sh"
#

. ~/.zsh/_utils.sh

script_setup
filePath=~/.tmexclude

title "Exclude files and directories from Time Machine"

if [[ ! -e "$filePath" ]]; then
  print_warning "Could not find \`.tmexclude\` in your root!"
  exit 1
fi

while IFS= read -r path || [[ -n "$path" ]]; do
  # this path is commented out or empty
  if [[ $path == \;* ]] || [[ -z $path ]]; then
    continue
  fi

  # replace tilde with home absolute path
  path=${path/\~/$HOME}

  # if the file or directory does not exist
  if [[ ! -e "$path" ]] && [[ ! -d "$path" ]]; then
    print_warning "Could not find $path"
    continue
  fi

  # get file or directory size
  sizeondisk=$(fileSize "$path")

  # if the file or directory is already excluded
  if tmutil isexcluded "$path" | grep -q '\[Excluded\]'; then
    print_info "Already excluded ${UNDERLINE}$path${RESET} ($sizeondisk)"
    continue
  fi

  # exclude the file or directory from Time Machine backups
  execute "tmutil addexclusion \"$path\"" " " "Excluding $path"

  if [[ "$exitCode" -eq 0 ]]; then
    print_success "Excluded $path ($sizeondisk)"
  else
    print_error "Failed with code: ${YELLOW}${exitCode}${RESET}\n\t$path"
  fi
done <$filePath

step "Done after ${SECONDS}s"
