#!/bin/bash

###############################################################################
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
#   https://github.com/lulivi/Latex-PDF-auto-updater
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
###############################################################################

# Help function
function help {
  echo "$0 <metafiles_directory> <latex_file_to_watch>"
}

# Check correct execution of the script
if [ "$#" -ne 2 ]; then
  help
  exit 1
fi

# Create directory if it doesn't exist
if [ ! -d $1 ]; then
	mkdir $1
fi

# Copy the pdf from the temporal directory to the parent directory
function listen_pdf_update {
  while true; do
    change=$(inotifywait -e close_write $1)
    echo "=================================="
    echo "$change"
    change=${change##* }
    if [ "$change" = "$2" ]; then
      cp $1/*.pdf ./
      echo "===> Moved pdf to parent directory"
    fi
    echo "=================================="
  done
}

# Set up listener for the target PDF file
listen_pdf_update $1 $2 &

# Set up latex listener for changes in the directory
latexmk -shell-escape -xelatex -pdf -pvc -output-directory=$1

# Kill all processes created in this script
kill -9 -$$
