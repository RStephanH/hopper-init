#!/usr/bin/env bash
set -euo pipefail 

# == Detect Linux Distro ==
distro=""
if [[ -f /etc/os-release ]]; then
  # source (import) the file so we get variable like ID, NAME, VERSION_ID
  . /etc/os-release
  distro=$ID
else
  echo "❌Could not detect distro (no /etc/os-release)"
  exit 1
fi

if [[ $ID == "arch" ]]; then
  echo "Damn it😯! You use Arch BTW!"
else 
  echo ">> Detected distro: $ID"
fi
