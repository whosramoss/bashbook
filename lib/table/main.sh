#!/bin/bash

source "lib/logger/main.sh"

# -------------------------------------------------------
# Category    :: TABLE
# Description :: Prints a formatted table with a header and rows, using fixed column width.
# -------------------------------------------------------
function sdx_show_table() {
  local header="$1"
  shift
  local rows=("$@")

  IFS='|' read -ra header_cols <<< "$header"
  local num_cols=${#header_cols[@]}

  local col_width=25
  local format=""
  for ((i=0; i<num_cols; i++)); do
    format+="%-${col_width}s "
  done
  format+="\n"

  printf "${WHITE}${format}${RESET}" "${header_cols[@]}"

  for ((i=0; i<num_cols; i++)); do
    printf "${DARK_GRAY}%-*s ${RESET}" "$col_width" "$(printf '%*s' $col_width | tr ' ' '-')"
  done
  echo

  for row in "${rows[@]}"; do
    IFS='|' read -ra cols <<< "$row"
    printf "$format" "${cols[@]}"
  done
}

# -------------------------------------------------------
# Category    :: TABLE
# Description :: Prints a formatted table with borders, using fixed column width.
# -------------------------------------------------------
function sdx_show_table_with_borders()  {
  local header="$1"
  shift
  local rows=("$@")

  local WHITE="\033[97m"
  local DARK_GRAY="\033[90m"
  local RESET="\033[0m"
  local BOLD="\033[1m"

  IFS='|' read -ra header_cols <<< "$header"
  local num_cols=${#header_cols[@]}

  local -a col_widths
  for ((i=0; i<num_cols; i++)); do
    col_widths[i]=${#header_cols[i]}
  done

  for row in "${rows[@]}"; do
    IFS='|' read -ra cols <<< "$row"
    for ((i=0; i<num_cols; i++)); do
      if [ ${#cols[i]} -gt ${col_widths[i]} ]; then
        col_widths[i]=${#cols[i]}
      fi
    done
  done

  for ((i=0; i<num_cols; i++)); do
    col_widths[i]=$((col_widths[i] + 2))
  done

  local sep_top="┌"
  for ((i=0; i<num_cols; i++)); do
    sep_top+=$(printf '%0.s─' $(seq 1 "${col_widths[i]}"))
    if (( i < num_cols - 1 )); then
      sep_top+="┬"
    else
      sep_top+="┐"
    fi
  done

  local sep_bottom="└"
  for ((i=0; i<num_cols; i++)); do
    sep_bottom+=$(printf '%0.s─' $(seq 1 "${col_widths[i]}"))
    if (( i < num_cols - 1 )); then
      sep_bottom+="┴"
    else
      sep_bottom+="┘"
    fi
  done

  local sep_mid="├"
  for ((i=0; i<num_cols; i++)); do
    sep_mid+=$(printf '%0.s─' $(seq 1 "${col_widths[i]}"))
    if (( i < num_cols - 1 )); then
      sep_mid+="┼"
    else
      sep_mid+="┤"
    fi
  done

  echo -e "${DARK_GRAY}$sep_top${RESET}"

  echo -n "│"
  for ((i=0; i<num_cols; i++)); do
    printf "${WHITE} %-*s ${DARK_GRAY}│${RESET}" "$((col_widths[i] - 2))" "${header_cols[i]}"
  done
  echo

  echo -e "${DARK_GRAY}$sep_mid${RESET}"

  for row in "${rows[@]}"; do
    IFS='|' read -ra cols <<< "$row"
    echo -n "│"
    for ((i=0; i<num_cols; i++)); do
      printf " %-*s ${DARK_GRAY}│${RESET}" "$((col_widths[i] - 2))" "${cols[i]}"
    done
    echo
  done

  echo -e "${DARK_GRAY}$sep_bottom${RESET}"
}

