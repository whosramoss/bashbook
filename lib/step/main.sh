#!/bin/bash

source "lib/logger/main.sh"

# -------------------------------------------------------
# Category    :: STEP
# Description :: Displays a spinner while a background process runs, then logs success or error.
# -------------------------------------------------------
function sdx_spinner_step() {
  local pid=$1
  local message=$2
  local spin_chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  local i=0

  tput civis 

  while kill -0 "$pid" 2>/dev/null; do
    printf "\r ${YELLOW}%s ${WHITE}%s${RESET}" "${spin_chars[$i]}" "$message"
    i=$(( (i + 1) % ${#spin_chars[@]} ))
    sleep 0.1
  done

  wait $pid
  local exit_code=$?
  printf "\r\033[K"
  tput cnorm  

  if [ $exit_code -eq 0 ]; then
    sdx_log_icon_success "${WHITE}$message${RESET}"
  else
    sdx_log_icon_error "${WHITE}$message${RESET}"
  fi

  return $exit_code
}

# -------------------------------------------------------
# Category    :: Step
# Description :: Runs a function in the background with spinner and handles its output and errors.
# -------------------------------------------------------
function sdx_run_step() {
  local cmd="$1"
  local message="$2"

  if ! declare -f "$cmd" > /dev/null; then
    sdx_log_icon_error "Error: '$cmd' is not a valid function."
    return 1
  fi

  local stdout_file
  local stderr_file
  stdout_file=$(mktemp)
  stderr_file=$(mktemp)

  {
    "$cmd" >"$stdout_file" 2>"$stderr_file"
  } &
  local pid=$!

  sdx_spinner_step $pid "$message"
  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    echo
    sdx_log_icon_error "Error output:"
    cat "$stderr_file"
    echo
  fi

  rm -f "$stdout_file" "$stderr_file"

  return $exit_code
}