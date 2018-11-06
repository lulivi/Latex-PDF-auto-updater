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
## SYNOPSIS
##       ${SCRIPT_NAME} [-f <file>] [-b <build_dir>]
##
## OPTIONS:
##
##       -f <file>
##              Specify the TeX file to from which create the pdf. If the file
##              is not specified, latexmk will search for one *.tex file in
##              the directory.
##
##       -b <build_dir>
##              Directory to store build files. DEFAULT: .latex_build
##
##       -u     Auto build pdf when saving document.
##
##       -c     Clean generated files (if you customized build directory in
##              previous runs, you must pass the same build directory name
##              along with this option, with -b <buil_dir>)
##

PREVIEWER="evince"

SCRIPT_NAME="$(basename "$0")"
SCRIPT_PATH="$(dirname "$0")"

usage() {
    grep -e "^##" "$SCRIPT_PATH"/"$SCRIPT_NAME" | \
        sed -e "s/^## \{0,1\}//g" \
            -e "s/\${SCRIPT_NAME}/"$SCRIPT_NAME"/g"
    exit 2
} 2>/dev/null

# Define default build dir
BUILD_DIR=".latex_builds"

# Define default file to convert in pdf
IN_DOC_NAME="$(find *.doc.tex)"

# Basic latexmk building arguments
BUILD_OPTS="-halt-on-error -shell-escape -bibtex -pdf -view=pdf"

while getopts "hf:b:uc" args; do
    case "${args}" in
        (h) usage 2>&1;;
        (f) IN_DOC_NAME="${OPTARG}";;
        (b) BUILD_DIR="${OPTARG}";;
        (u) BUILD_OPTS="$BUILD_OPTS -pvc";;
        (c) CLEAR_CMD="t";;
        (--) shift; break;;
        (-*) usage "${1}: unknown option";;
        (*) usage;;
    esac
done
shift $((OPTIND-1))

# Obtain basename for output files
BASE_DOC_NAME="${IN_DOC_NAME/.*}"

# Remove created files and directories if CLEAR_CMD gets a value
if [ ! -z "$CLEAR_CMD" ]; then
    rm -r "$BUILD_DIR"
    rm "$BASE_DOC_NAME.pdf" 2>/dev/null
    exit 0
fi

# Create build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

previwer_rule=$(printf '$pdf_previewer=q/%s/' "$PREVIEWER")

# Define final arguments to the latexmk command
BUILD_OPTS="$BUILD_OPTS -output-directory=$BUILD_DIR -jobname=$BASE_DOC_NAME"

# Set up latex listener for changes in the directory. Also, use success_cmd to
# execute copy command after compilation
latexmk $BUILD_OPTS -e '$success_cmd=q/cp %D ./;'\
                    -e $previwer_rule "$IN_DOC_NAME"

# Execute copy command to update root directory pdf if running script in one
# time mode, because latexmk doesn't execute $success_cmd command if running
# without -pvc option
cp -f "$BUILD_DIR/$BASE_DOC_NAME.pdf" . 2>/dev/null

# Kill all processes created in this script
kill -9 -$$  2>/dev/null
