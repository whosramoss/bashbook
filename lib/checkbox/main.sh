#!/bin/bash

source "lib/logger/main.sh"

# -------------------------------------------------------
# Category    :: CHECKBOX
# Description :: Displays a checkbox list menu to select and run multiple scripts.
# -------------------------------------------------------
function sdx_set_checkbox_list() {
  local -n options_ref=$1
  local -n scripts_ref=$2
  local header_message=$3

  local selected=()
  local current=0

  for ((i=0; i<${#options_ref[@]}; i++)); do
    selected[i]=0
  done

  draw_menu() {
    clear
    echo -e "${header_message}"
    echo
    for i in "${!options_ref[@]}"; do
      local prefix=" "
      local status="○"
      local color=""

      if [[ ${selected[i]} -eq 1 ]]; then
        status="●"
        color="${LIGHT_GREEN}"
      fi

      if [[ $i -eq $current ]]; then
        prefix=">"
        color="${LIGHT_CYAN}"
      fi

      echo -e "${color}${prefix} ${status} ${RESET}${options_ref[i]}"
    done
  }

  while true; do
    printf "\033c"
    draw_menu
    IFS= read -rsn1 key1
    if [[ $key1 == $'\x1b' ]]; then
      read -rsn2 key2
      case "$key2" in
        "[A") ((current--)); ((current < 0)) && current=$((${#options_ref[@]} - 1)) ;;
        "[B") ((current++)); ((current >= ${#options_ref[@]})) && current=0 ;;
      esac
    elif [[ $key1 == " " ]]; then
      selected[current]=$((1 - selected[current]))
    elif [[ $key1 == "" ]]; then
      break
    fi
  done

  printf "\033c"
  any_selected=false
  item_line=""

  for i in "${!options_ref[@]}"; do
    if [[ ${selected[i]} -eq 1 ]]; then
      if [ "$any_selected" = true ]; then
        item_line+=", "
      fi
      item_line+="${options_ref[i]}"
      any_selected=true
    fi
  done

  echo -e "${header_message}"
  echo -e "${WHITE}> options: ${LIGHT_CYAN}$item_line${RESET}"


  if ! $any_selected; then
    echo -e "${WHITE}(No features selected)${RESET}"
    return
  fi

  sleep 2

  for i in "${!options_ref[@]}"; do
    if [[ ${selected[i]} -eq 1 ]]; then
      local script="${scripts_ref[i]}"
      if [[ -f "$script" && -x "$script" ]]; then
        echo
        echo
        sdx_log_icon_info "Running: ${LIGHT_CYAN}${options_ref} ${DARK_GRAY}($script)${RESET}"
        "$script"
      elif [[ -f "$script" ]]; then
        echo
        echo
        sdx_log_icon_info "Running: ${LIGHT_CYAN}${options_ref} ${DARK_GRAY}($script)${RESET}"
        bash "$script"
      else
        sdx_log_icon_warning "Script not found: ${WHITE}$script${RESET}"
      fi
    fi
  done
}
