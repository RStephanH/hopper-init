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
      sudo pacman -S --needed --noconfirm "$@"
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

ensure_installed(){
  local_tool=("$@")
  for tool in "${local_tool[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      missing_tools+=("$tool")
    else
      echo "✅ $tool already installed !"
    fi
  done

  echo "The missing tools are :"

  for miss  in "${missing_tools[@]}"; do
    echo "$miss"
  done

  if [[ "${#missing_tools[@]}" -gt 0 ]]; then
    echo ">>> Installing missing packages : ${missing_tools[*]}"
    install_pkg "${missing_tools[@]}"
  else 
    echo ">>> All the requested tools are already installed"
  fi

}

basic_tools=("curl" "wget" "git" "unzip")
ensure_installed "${basic_tools[@]}"

# == Export functions for other modules ===
export -f install_pkg
export -f ensure_installed
