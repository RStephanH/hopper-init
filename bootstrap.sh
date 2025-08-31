#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="./modules"

#Default: run all in numeric order
module_to_run=($(ls "$MODULE_DIR" | sort ))

#Parse args
for arg  in "$@"; do
  case $arg in 
    --only=*)
      only_list="${arg#*=}"
      IFS=',' read -r -a module_to_run <<< "$only_list"
      ;;
    --skip=*)
      skip_list="${arg#*=}"
      for skip in $(echo "$skip_list" | tr ',' ' ');do
        module_to_run=(${module_to_run[@]/$skip/})
      done
      ;;
    --dry-run)
      DRY-RUN=1
      ;;
  esac
done

for module in "${module_to_run[@]}"; do 
  echo ">> Running module : $module "
  if [[ -n "${DRY-RUN: -}"]]; then
    echo "[dry-run] $MODULE_DIR/$module"
  else
    bash "$MODULE_DIR/$module"
  fi
done


