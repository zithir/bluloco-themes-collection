#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: ${0##*/} [-f]

Install all Zed themes from this directory into the Zed themes configuration directory.

Options:
  -f    Overwrite existing theme files.
USAGE
}

force=false
while getopts ":fh" opt; do
  case "$opt" in
    f) force=true ;;
    h)
      usage
      exit 0
      ;;
    ?)
      usage >&2
      exit 1
      ;;
  esac
done

src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest_dir="${HOME}/.config/zed/themes"

mkdir -p "$dest_dir"

shopt -s nullglob

theme_files=("$src_dir"/*.json)
if (( ${#theme_files[@]} == 0 )); then
  echo "No theme files found in $src_dir" >&2
  exit 0
fi

for theme in "${theme_files[@]}"; do
  theme_name="${theme##*/}"
  dest_path="$dest_dir/$theme_name"

  if [[ -e "$dest_path" && $force == false ]]; then
    echo "Skipping $theme_name (already exists). Use -f to overwrite."
    continue
  fi

  if [[ -e "$dest_path" && $force == true ]]; then
    echo "Overwriting $theme_name"
  else
    echo "Installing $theme_name"
  fi

  cp "$theme" "$dest_path"
done
