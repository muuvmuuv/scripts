#!/usr/bin/env bash

origin="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. $origin/_utils.sh
script_setup

title "Exclude files and directories from Time Machine"
version $@ "0.3.0"

__usage="
  Simple script to exclude folders and files from Time Machine backups
  from a file. This is good for automating the exclution of files and
  folders.

  Usage:

    1. Create a file in your root folder: ~/.tmexclude (.ini format)
    2. On each line put a absolute file, directory or glob you want to exclude
    3. Run \`bash ${scriptname}\`

  Or put it in your ~/.zprofile:

    alias tmexclude=\"bash ~/.scripts/${scriptname}\"
"

if [ "$1" == "--help" ] || [ "$1" == "help" ]; then
  show_usage "$__usage"
  exit 100
fi

filePath=~/.tmexclude

if [[ ! -e "$filePath" ]]; then
  print_warning "Could not find \`.tmexclude\` in your users root!"
  exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
  # this line is a comment or empty
  if [[ $line == \;* ]] || [[ -z $line ]]; then
    continue
  fi

  # replace tilde with home absolute path
  glob=${line/\~/$HOME}

  for path in $glob; do
    # if the file or directory does not exist
    if [[ ! -e "$path" ]] && [[ ! -d "$path" ]]; then
      print_warning "Could not find ${UNDERLINE}$path${RESET}"
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
  done
done <$filePath
