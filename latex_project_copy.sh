#!/usr/bin/env bash
# Copyright (c) 2018 Luis Liñán <luislivilla at gmail.com>
readonly SCRIPT_PATH="$(dirname "$0")"
readonly SOURCE_DIR="$SCRIPT_PATH/src"
readonly TARGET_DIR="${1:-"$(pwd)"}"

if [ ! -d "$SOURCE_DIR" ] ; then
    printf 'Error, %s is not a directory\n' "$SOURCE_DIR"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    printf 'Error %s is not a directory\n' "$TARGET_DIR"
    exit 1
fi

printf 'Copying LaTeX project...\n'
printf '  from %s\n' "$SOURCE_DIR"
printf '  to   %s\n' "$TARGET_DIR"

ln -s "${SOURCE_DIR}/update_pdf_latex.sh" "$TARGET_DIR"
cd    "$SOURCE_DIR"
cp -r $(ls --hide="update_pdf_latex.sh") "$TARGET_DIR"
