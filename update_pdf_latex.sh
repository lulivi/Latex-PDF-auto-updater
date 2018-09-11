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

SCRIPT_NAME="$(basename ${0})"
SCRIPT_PATH="$(dirname ${0})"

usage() {
    grep -e "^##" $SCRIPT_PATH/$SCRIPT_NAME | \
        sed -e "s/^## \{0,1\}//g" \
            -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"
    exit 2
} 2>/dev/null

LATEX_FILE=""
BUILD_DIR=""

while getopts "hf:b:" args; do
    case "${args}" in
        (h)
            usage 2>&1
            ;;
        (f)
            LATEX_FILE=${OPTARG}
            ;;
        (b)
            BUILD_DIR=${OPTARG}
            ;;
        (--)
            shift; break
            ;;
        (-*)
            usage "$1: unknown option"
            ;;
        (*)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

[ $BUILD_DIR ] || BUILD_DIR=".latex_builds"

# Create directory if it doesn't exist
[ ! -d $BUILD_DIR ] && {
  mkdir -p $BUILD_DIR
}

# Copy the pdf from the temporal directory to the parent directory
listen_pdf_update() {
  pdf_substring='(.*[.]pdf.*)'
  while true; do
    change=$(inotifywait -e close_write $1)

    if [[ $change =~ $pdf_substring ]]; then
      cp $1/*.pdf ./
      echo "============> iNotify <============"
      echo "==>   Updated parent pdf file   <=="
      echo "==================================="
    fi
  done
}

# Set up listener for the target PDF file
listen_pdf_update $BUILD_DIR &

# Set up latex listener for changes in the directory
latexmk -shell-escape -silent -bibtex -view=pdf -xelatex -pdf -pvc \
       -output-directory=$BUILD_DIR $LATEX_FILE

# Kill all processes created in this script
kill -9 -$$
