#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# jump1.sh - Change cwd to any directory in any path in your home directory

# Copyright 2022, Julius Stolz <just01120@gmail.com>
  
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.

# Usage: jump1.sh [-h|--help]
#        jump1.sh [-d|--dots]

# Revision history:
# 2022-02-14 Created by new_script ver. 3.5.3
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}
VERSION="0.1"
NEW_HOME=${HOME//\//\\\/}

usage() {
  printf "%s\n" "Usage: ${PROGNAME} [-h|--help]"
  printf "%s\n" "       ${PROGNAME} [-d|--option_1]"
}

help_message() {
  cat <<- _EOF_
$PROGNAME ver. $VERSION
Change cwd to any directory in any path in your home directory

$(usage)

  Options:
  -h, --help                  Display this help message and exit.
  -d, --dots                  Allow directorys to start with "."

_EOF_
  return
}

# Main logic

jump () {

  # Parse command-line
  while [[ -n "$1" ]]; do
    case "$1" in
      -h | --help)
        help_message
        return
        ;;
      -d | --option_1)
        echo "Allow directorys to start with ".""
        shift
        count=$(find ~ -type d -a -name "$1" | wc -l)
        list=$(find ~ -type d -a -name "$1")

        if (( count > 1 )); then
          cat -n <<< "exit" | sed 's/1/0/'
          cat -n <<< "$list" | sed "s/$NEW_HOME/\~/g"
          echo -n "Select directory to jump to --> "
          read directory
          if (( directory == 0 )); then
            return
          fi
          cd $(cat <<< "$list" | head -n $directory | tail -n 1)

        elif (( count == 1 )); then
          cd $list
          
        else
          echo "No directory found"
        fi
        return
        ;;
      --* | -*)
        usage >&2
        exit 1 "Unknown option $1"
        ;;
      *)  
        count=$(find ~ -type d -not -regex ".*\..*" -a -name "$1" | wc -l)
        list=$(find ~ -type d -not -regex ".*/\..*" -a -name "$1")

        if (( count > 1 )); then
          cat -n <<< "exit" | sed 's/1/0/'
          cat -n <<< "$list" | sed "s/$NEW_HOME/\~/g"
          echo -n "Select directory to jump to --> "
          read directory
          if (( directory == 0 )); then
            return
          fi
          cd $(cat <<< "$list" | head -n $directory | tail -n 1)

        elif (( count == 1 )); then
          cd $list
          
        else
          echo "No directory found"
        fi
        return
    esac
  done

}
