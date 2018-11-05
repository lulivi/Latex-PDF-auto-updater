#!/usr/bin/env bash
#==============================================================================
# FILENAME :
#   updatePdfLatex.sh
#
# DESCRIPTION :
#   Updates the pdf in a temporal directory and brings it back to
#   main directory.
#
# AUTHOR :
#   Copyright 2017, Luis Liñán (luislivilla at gmail.com)
#
# REPOSITORY :
#   https://github.com/lulivi/latex-project-example
#
# LICENSE :
#   This program is free software: you can redistribute it and/or
#   modify it under the terms of the GNU General Public License
#   as published by the Free Software Foundation, version 3.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE. See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>
#==============================================================================
##
## Usage: ${SCRIPT_NAME} [-f <file>] [-b <build_dir>]
##
## Options:
##   -f <file>           Specify the TeX file to from which create the pdf.
##                       If the file is not specified, latexmk will search for
##                       one *.tex file in the directory.
##   -b <build_dir>      Directory to store build files. DEFAULT: .latex_build
##
##   -u                  Auto build pdf when saving document.
##

trap trap_int INT

SCRIPT_NAME="$(basename "$0")"
SCRIPT_PATH="$(dirname "$0")"

trap_int() {
    printf 'Exiting %s...\n' "$SCRIPT_NAME"
    exit 0
}

usage() {
    grep -e "^##" "$SCRIPT_PATH"/"$SCRIPT_NAME" | \
        sed -e "s/^## \{0,1\}//g" \
            -e "s/\${SCRIPT_NAME}/"$SCRIPT_NAME"/g"
    exit 2
} 2>/dev/null

BUILD_DIR=".latex_builds"
IN_DOC_NAME="$(find *.doc.tex)"
BUILD_OPTS="-halt-on-error -shell-escape -bibtex -xelatex -pdf -view=pdf"

while getopts "hf:b:u" args; do
    case "${args}" in
        (h)
            usage 2>&1
            ;;
        (f)
            IN_DOC_NAME="${OPTARG}"
            ;;
        (b)
            BUILD_DIR="${OPTARG}"
            ;;
        (u)
            BUILD_OPTS="$BUILD_OPTS -pvc"
            ;;
        (--)
            shift; break
            ;;
        (-*)
            usage "${1}: unknown option"
            ;;
        (*)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Create build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

OUT_DOC_NAME="${IN_DOC_NAME/.*}"
BUILD_OPTS="$BUILD_OPTS -jobname=$OUT_DOC_NAME"

# Copy the pdf from the temporal directory to the parent directory
listen_pdf_update() {
  file_name="$1"
  while true; do
    inotifywait -e close_write "$file_name"
    cp "$file_name" ./
    printf "============> iNotify <============\n"
    printf "==>   Updated parent pdf file   <==\n"
    printf "===================================\n"
  done
}

# Set up listener for the target PDF file
listen_pdf_update "$BUILD_DIR/$OUT_DOC_NAME.pdf" &

# Set up latex listener for changes in the directory
latexmk $BUILD_OPTS -output-directory="$BUILD_DIR" "$IN_DOC_NAME"

# Kill all processes created in this script
kill -9 -$$  2>/dev/null
