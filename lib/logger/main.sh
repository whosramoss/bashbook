#!/bin/bash

# === styles ===
RESET="\033[0m"
BOLD="\033[1;30m"
UNDERLINE="\033[4;30m"
BLINK="\033[5;30m"
REVERSE="\033[7;30m"
CONCEALED="\033[8;30m "

# === Text colors (default) ===
BLACK="\e[0;30m"
RED="\e[0;31m"
GREEN="\e[0;32m"
BROWN="\e[0;33m"
BLUE="\e[0;34m"
PURPLE="\e[0;35m"
CYAN="\e[0;36m"
LIGHT_GRAY="\e[0;37m"

# === Text colors (light/dark) ===
DARK_GRAY="\e[1;30m"
LIGHT_RED="\e[1;31m"
LIGHT_GREEN="\e[1;32m"
YELLOW="\e[1;33m"
LIGHT_BLUE="\e[1;34m"
LIGHT_PURPLE="\e[1;35m"
LIGHT_CYAN="\e[1;36m"
WHITE="\e[1;37m"

# === Backgrounds ===
BG_BLACK="\e[40;1;37m"
BG_RED="\e[41;1;37m"
BG_GREEN="\e[42;1;37m"
BG_BROWN="\e[43;1;37m"
BG_BLUE="\e[44;1;37m"
BG_PURPLE="\e[45;1;37m"
BG_CYAN="\e[46;1;37m"
BG_GRAY="\e[47;1;37m"

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: log text in different color.
# -------------------------------------------------------
function sdx_log_black()          { echo -e " ${BLACK}$1${RESET} ${2}"; }
function sdx_log_red()            { echo -e " ${RED}$1${RESET} ${2}"; }
function sdx_log_green()          { echo -e " ${GREEN}$1${RESET} ${2}"; }
function sdx_log_brown()          { echo -e " ${BROWN}$1${RESET} ${2}"; }
function sdx_log_blue()           { echo -e " ${BLUE}$1${RESET} ${2}"; }
function sdx_log_purple()         { echo -e " ${PURPLE}$1${RESET} ${2}"; }
function sdx_log_cyan()           { echo -e " ${CYAN}$1${RESET} ${2}"; }
function sdx_log_light_gray()     { echo -e " ${LIGHT_GRAY}$1${RESET} ${2}"; }

function sdx_log_dark_gray()      { echo -e " ${DARK_GRAY}$1${RESET} ${2}"; }
function sdx_log_light_red()      { echo -e " ${LIGHT_RED}$1${RESET} ${2}"; }
function sdx_log_light_green()    { echo -e " ${LIGHT_GREEN}$1${RESET} ${2}"; }
function sdx_log_yellow()         { echo -e " ${YELLOW}$1${RESET} ${2}"; }
function sdx_log_light_blue()     { echo -e " ${LIGHT_BLUE}$1${RESET} ${2}"; }
function sdx_log_light_purple()   { echo -e " ${LIGHT_PURPLE}$1${RESET} ${2}"; }
function sdx_log_light_cyan()     { echo -e " ${LIGHT_CYAN}$1${RESET} ${2}"; }
function sdx_log_white()          { echo -e " ${WHITE}$1${RESET} ${2}"; }

function sdx_log_bg_black()       { echo -e " ${BG_BLACK}$1${RESET} ${2}"; }
function sdx_log_bg_red()         { echo -e " ${BG_RED}$1${RESET} ${2}"; }
function sdx_log_bg_green()       { echo -e " ${BG_GREEN}$1${RESET} ${2}"; }
function sdx_log_bg_brown()       { echo -e " ${BG_BROWN}$1${RESET} ${2}"; }
function sdx_log_bg_blue()        { echo -e " ${BG_BLUE}$1${RESET} ${2}"; }
function sdx_log_bg_purple()      { echo -e " ${BG_PURPLE}$1${RESET} ${2}"; }
function sdx_log_bg_cyan()        { echo -e " ${BG_CYAN}$1${RESET} ${2}"; }
function sdx_log_bg_gray()        { echo -e " ${BG_GRAY}$1${RESET} ${2}"; }

function sdx_log_underline()      { echo -e " ${UNDERLINE}$1${RESET} ${2}"; }
function sdx_log_blink()          { echo -e " ${BLINK}$1${RESET} ${2}"; }
function sdx_log_reverse()        { echo -e " ${REVERSE}$1${RESET} ${2}"; }
function sdx_log_concealed()      { echo -e " ${CONCEALED}$1${RESET} ${2}"; }

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Calls a given log function with provided arguments.
# -------------------------------------------------------
function sdx_log_color() {
  local func=$1   
  shift          
  $func "$@"      
}


# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a success message.
# -------------------------------------------------------
function sdx_log_icon_success() { sdx_log_color sdx_log_light_green "✔" "$@"; }
function sdx_log_text_success() { sdx_log_color sdx_log_light_green "[SUCCESS]" "$@"; }

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs an info message.
# -------------------------------------------------------
function sdx_log_icon_info()    { sdx_log_color sdx_log_light_cyan "i" "$@"; }
function sdx_log_text_info()    { sdx_log_color sdx_log_light_cyan "[INFO]" "$@"; }


# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a warning message.
# -------------------------------------------------------
function sdx_log_icon_warning() { sdx_log_color sdx_log_yellow "⚠" "$@"; }
function sdx_log_text_warning() { sdx_log_color sdx_log_yellow "[WARNING]" "$@"; }

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs an error message.
# -------------------------------------------------------
function sdx_log_icon_error()   { sdx_log_color sdx_log_light_red "✖" "$@"; }
function sdx_log_text_error()   { sdx_log_color sdx_log_light_red "[ERROR]" "$@"; }


# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a question message.
# -------------------------------------------------------
function sdx_log_icon_question(){ sdx_log_color sdx_log_light_green "?" "${WHITE}$@${RESET}"; }
function sdx_log_text_question(){ sdx_log_color sdx_log_light_green "[QUESTION]" "$@"; }


# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a section header with a bordered title and subtitle.
# -------------------------------------------------------
function sdx_log_section(){
  sdx_log_light_green "-------------------------------------------------------"
  echo -e " ${LIGHT_GREEN}===${RESET} ${WHITE}$1${RESET} ${LIGHT_GREEN}===${RESET}"
  echo 
  echo " $2"
  echo  
}

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a topic header with an arrow indicator.
# -------------------------------------------------------
function sdx_log_topic(){
  echo
  echo -e "${WHITE}➤ $1${RESET} "
  echo 
}

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Prompts a yes/no question and returns 0 for yes, 1 for no.
# -------------------------------------------------------
function sdx_log_question_yes_no() {
  local prompt="$1"
  echo -en "$(sdx_log_color sdx_log_light_green "?") ${WHITE}${prompt} ${DARK_GRAY}[y/N]${RESET} "
  read -r answer
  tput cuu1 && tput el

  case "$answer" in
    [yY][eE][sS]|[yY])
      echo -e "$(sdx_log_color sdx_log_light_green "?") ${WHITE}${prompt} ${LIGHT_BLUE}Yes${RESET}"
      return 0
      ;;
    *)
      echo -e "$(sdx_log_color sdx_log_light_green "?") ${WHITE}${prompt} ${LIGHT_BLUE}No${RESET}"
      return 1
      ;;
  esac
}

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Highlights a message with a green bordered box.
# -------------------------------------------------------
function sdx_log_highlight_message() {
  local message="$1"
  local min_length=9
  local length=${#message}
  local line_length=$length

  if [ $line_length -lt $min_length ]; then
    line_length=$min_length
  fi

  local line=$(printf '%0.s─' $(seq 1 "$((line_length + 2))"))
  local padding=$(( line_length - length ))
  local spaces=$(printf '%*s' "$padding")
  echo -e "${WHITE}┌${line}┐${RESET}"
  echo -e "${WHITE}│ ${RESET}${message}${spaces}${WHITE} │${RESET}"
  echo -e "${WHITE}└${line}┘${RESET}"
}