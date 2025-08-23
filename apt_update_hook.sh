#!/usr/bin/env bash


## Author: Tommy Miland (@tmiland) - Copyright (c) 2025


######################################################################
####                     Apt Update Hook.sh                       ####
####               Apt update hook that wil ask if                ####
####                 user wants to update or not                  ####
####                   Maintained by @tmiland                     ####
######################################################################

VERSION='1.0.2'

#------------------------------------------------------------------------------#
#
# MIT License
#
# Copyright (c) 2025 Tommy Miland
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#------------------------------------------------------------------------------#
# scolors - Color constants
# canonical source http://github.com/swelljoe/scolors

# do we have tput?
if which 'tput' > /dev/null; then
  # do we have a terminal?
  if [ -t 1 ]; then
    # does the terminal have colors?
    ncolors=$(tput colors)
    if [ "$ncolors" -ge 8 ]; then
      RED=$(tput setaf 1)
      GREEN=$(tput setaf 2)
      YELLOW=$(tput setaf 3)
      CYAN=$(tput setaf 6)
      NORMAL=$(tput sgr0)
    fi
  fi
else
  echo "tput not found, colorized output disabled."
  GREEN=''
  YELLOW=''
  CYAN=''
  NORMAL=''
fi

# Print an error message and exit (Red)
error() {
  printf "${RED}ERROR: %s${NORMAL}\n" "$*" >&2
  exit 1
}

# Print a log message (Green)
ok() {
  printf "${GREEN}%s${NORMAL}\n" "$*"
}

warn() {
  printf "${YELLOW}%s${NORMAL}\n" "$*"
}

# https://gist.github.com/imthenachoman/f722f6d08dfb404fed2a3b2d83263118
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=770938
# this script is an enhancement of https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=770938
# we need to work up the process tree to find the apt command that triggered the call to this script
# get the initial PID
PID=$$
# find the apt command by working up the process tree
# loop until
# - PID is empty
# - PID is 1
# - or PID command is apt
while [[ -n "$PID" && "$PID" != "1" && "$(ps -ho comm "${PID}")" != "apt" ]] ; do
  # the current PID is not the apt command so go up one by getting the parent PID of hte current PID
  PID=$(ps -ho ppid "$PID" | xargs)
done
# assuming we found the apt command, get the full args
if [[ "$(ps -ho comm "${PID}")" = "apt" ]] ; then
  LAST_CMD="$(ps -ho args "${PID}")"
fi

if [[ -n "$LAST_CMD" ]] && [[ "$LAST_CMD" == "apt update" ]]
then
  got_upgrades=$(apt list --upgradable 2>/dev/null | sed "s|Listing...||g")
  if [ -n "$got_upgrades" ]; then
    echo
    ok "Updates are available"
    echo
    echo "$got_upgrades" | sed '/^[[:space:]]*$/d' | while read -r line
    do
      line1=$(echo "$line" | cut -d '/' -f1)
      line2=$(echo "$line" | cut -d '/' -f2)
      got_upgrades="${GREEN}${line1}${NORMAL}/${line2}"
      echo "$got_upgrades"
    done
    echo
    read -rp "${YELLOW}Do you want to upgrade?${NORMAL} [y/n] " q
    if [ "$q" == "y" ]; then
      sudo apt upgrade || error "Something went wrong..."
    fi
  fi
fi

exit 0
