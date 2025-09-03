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

install_pkg(){

  case "$distro" in
    arch|manjaro|endeavouros|cachyos)
      sudo pacman --needed --noconfirm "$@"
      ;;
    debian|ubuntu|kali)
      sudo apt update 
      sudo apt install -y "$@"
      ;;
    fedora)
      sudo dnf install -y "$@"
      ;;
    opensuse*)
      sudo zypper install -y "$@"
      ;;
    *)
      echo "❌Unsupported distro : $distro"
  esac

}

basic_tools=("curl" "wget" "git" "unzip")
for tool in basic_tools; do
  command ...
done
