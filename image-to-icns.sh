#!/usr/bin/env bash

origin="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. $origin/_utils.sh
script_setup

title "Converting file to icns/iconset"
version $@ "0.3.0"

__usage="
  Simple script to create an icns file and iconset from any image file.
  If you want to not delete the iconset at the end use the \`-I\` flag.

  Usage:

    > bash ${scriptname} ./path/to/image.svg
    > bash ${scriptname} -I ./path/to/image.svg

  Or put it in your ~/.zprofile:

    alias icnsc=\"bash ~/.scripts/${scriptname}\"
"

keep_iconset=false
filepath="$1"
steps=3
while getopts ':I' flag; do
  case "$flag" in
  I)
    keep_iconset=true
    steps=2
    filepath="$2"
    ;;
  *)
    show_usage "$__usage"
    exit 1
    ;;
  esac
done

if [ "$#" -eq 0 ] || [ -z "$filepath" ]; then
  show_usage "$__usage"
  exit 100
fi

file=$(basename "$filepath")
filedir=$(dirname "$filepath")
filename=${file%.*}
filext=${file##*.}

dest="${filedir}/${filename}.iconset"
mkdir -p $dest

#
# Creating iconset
#

headline "Creating iconset"

sizes=(
  "16x16 16x16"
  "32x32 16x16@2x"
  "32x32 32x32"
  "64x64 32x32@2x"
  "128x128 128x128"
  "256x256 128x128@2x"
  "256x256 256x256"
  "512x512 256x256@2x"
  "512x512 512x512"
  "1024x1024 512x512@2x"
)

for s in "${sizes[@]}"; do
  arr=(${s// / })
  size=${arr[0]}
  name=${arr[1]}

  execute "convert -background none -resize '!${size}' ${filepath} ${dest}/icon_${name}.png" "" "Converting to ${size}"
  handle_exit "Successfully convert to ${name}.png"
done

step "1/$steps"

#
# Creating icns file
#

headline "Creating icns file"

execute "iconutil -c icns $dest" "" "Creating icns"
handle_exit "Successfully created icns"

step "2/$steps"

#
# Removing iconset
#

if ! $keep_iconset; then
  headline "Removing iconset"

  execute "rm -rf $dest" "" "Removing $dest"
  handle_exit "Successfully removed"

  step "3/$steps"
fi

script_end
