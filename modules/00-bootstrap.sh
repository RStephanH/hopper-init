#!/usr/bin/env bash
set -euo pipefail 

# == Detect Linux Distro ==
distro_detect(){

  local distro=""
  if [[ -f /etc/os-release ]]; then
    #Load vars in a subshell to avoid global pollution 
    local -A os_vars
    while IFS='=' read -r key value; do
      #skip comments and empty lines 
      [[ $key == \#* || -z $key ]] && continue 
      #Unquote value if needed (basic handling) 
      value="${value//\"/}"
      value="${value//\'/}"
      os_vars[$key]=$value
    done < /etc/os-release

    distro="${os_vars[ID]:-}"
  fi

  if [[ -z $distro ]]; then
    echo "❌ Could not detect distro (no /etc/os-release or missing ID)" >&2
    return 1
  fi

  if [[ $distro == "arch" ]]; then
    echo "Damn it😯! You use Arch BTW!"
  else
    echo ">> Detected distro: $distro"
  fi

  echo "$distro"  # Output the distro for caller to capture
  return 0
}

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

# == test section ==-

DISTRO=$(distro_detect)
echo "$DISTRO"
# distro_detect
