#!/bin/bash

source "lib/logger/main.sh"

# -------------------------------------------------------
# Category    :: MENU
# Description :: Displays an interactive menu to execute scripts using arrow keys and Enter.
# -------------------------------------------------------
function sdx_set_menu() {
  if [[ $# -ne 2 ]]; then
    echo "Uso: sdx_set_menu <options_array_name> <files_array_name>"
    exit 1
  fi

  local -n _options=$1
  local -n _files=$2

  local esc=$(printf "\033")
  local selected=0

  for _file in "${_files[@]}"; do
    chmod +x "$_file"
  done


  while true; do
    echo
    for i in "${!_options[@]}"; do
      if [[ $i -eq $selected ]]; then
        sdx_log_light_cyan "> ${_options[$i]}"
      else
        echo "  ${_options[$i]}"
      fi
    done

    local quit_index=${#_options[@]}
    if [[ $selected -eq $quit_index ]]; then
      sdx_log_light_cyan "> Quit"
    else
      echo "  Quit"
    fi

    read -rsn1 key
    if [[ $key == $esc ]]; then
      read -rsn2 key
      case $key in
        "[A") ((selected--)); ((selected < 0)) && selected=$quit_index ;;
        "[B") ((selected++)); ((selected > quit_index)) && selected=0 ;;
      esac
    elif [[ $key == "" ]]; then
      echo

      if [[ $selected -eq $quit_index ]]; then
        echo "Bye..."
        exit 0
      fi

      local choice="${_options[$selected]}"
      local selected_script="${_files[$selected]}"

      # echo "Option selected: $choice"

      if [[ -x "$selected_script" ]]; then
        "$selected_script"
      else
        echo "Error: Script not found or no execution permission: $selected_script"
      fi

      echo -e "\nPress any key to return to the menu..."
      read -rsn1
    fi

    tput cuu $(( ${#_options[@]} + 2 )) 
    tput ed
  done
}