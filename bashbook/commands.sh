# #!/bin/bash


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
function book_log_black()          { echo -e " ${BLACK}$1${RESET} ${2}"; }
function book_log_red()            { echo -e " ${RED}$1${RESET} ${2}"; }
function book_log_green()          { echo -e " ${GREEN}$1${RESET} ${2}"; }
function book_log_brown()          { echo -e " ${BROWN}$1${RESET} ${2}"; }
function book_log_blue()           { echo -e " ${BLUE}$1${RESET} ${2}"; }
function book_log_purple()         { echo -e " ${PURPLE}$1${RESET} ${2}"; }
function book_log_cyan()           { echo -e " ${CYAN}$1${RESET} ${2}"; }
function book_log_light_gray()     { echo -e " ${LIGHT_GRAY}$1${RESET} ${2}"; }

function book_log_dark_gray()      { echo -e " ${DARK_GRAY}$1${RESET} ${2}"; }
function book_log_light_red()      { echo -e " ${LIGHT_RED}$1${RESET} ${2}"; }
function book_log_light_green()    { echo -e " ${LIGHT_GREEN}$1${RESET} ${2}"; }
function book_log_yellow()         { echo -e " ${YELLOW}$1${RESET} ${2}"; }
function book_log_light_blue()     { echo -e " ${LIGHT_BLUE}$1${RESET} ${2}"; }
function book_log_light_purple()   { echo -e " ${LIGHT_PURPLE}$1${RESET} ${2}"; }
function book_log_light_cyan()     { echo -e " ${LIGHT_CYAN}$1${RESET} ${2}"; }
function book_log_white()          { echo -e " ${WHITE}$1${RESET} ${2}"; }

function book_log_bg_black()       { echo -e " ${BG_BLACK}$1${RESET} ${2}"; }
function book_log_bg_red()         { echo -e " ${BG_RED}$1${RESET} ${2}"; }
function book_log_bg_green()       { echo -e " ${BG_GREEN}$1${RESET} ${2}"; }
function book_log_bg_brown()       { echo -e " ${BG_BROWN}$1${RESET} ${2}"; }
function book_log_bg_blue()        { echo -e " ${BG_BLUE}$1${RESET} ${2}"; }
function book_log_bg_purple()      { echo -e " ${BG_PURPLE}$1${RESET} ${2}"; }
function book_log_bg_cyan()        { echo -e " ${BG_CYAN}$1${RESET} ${2}"; }
function book_log_bg_gray()        { echo -e " ${BG_GRAY}$1${RESET} ${2}"; }

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Calls a given log function with provided arguments.
# -------------------------------------------------------
function book_log_color() {
  local func=$1   
  shift          
  $func "$@"      
}

# -------------------------------------------------------
# Category    :: SYSTEM
# Description :: Detect host operating system (Linux / Windows).
# -------------------------------------------------------
function book_is_linux() {
  [[ "$OSTYPE" == linux-gnu* ]]
}

function book_is_windows() {
  [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]
}

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a success message.
# -------------------------------------------------------
function book_log_icon_success() { book_log_color book_log_light_green "✔" "$@"; }
function book_log_text_success() { book_log_color book_log_light_green "[SUCCESS]" "$@"; }

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs an info message.
# -------------------------------------------------------
function book_log_icon_info()    { book_log_color book_log_light_cyan "i" "$@"; }
function book_log_text_info()    { book_log_color book_log_light_cyan "[INFO]" "$@"; }


# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a warning message.
# -------------------------------------------------------
function book_log_icon_warning() { book_log_color book_log_yellow "⚠" "$@"; }
function book_log_text_warning() { book_log_color book_log_yellow "[WARNING]" "$@"; }

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs an error message.
# -------------------------------------------------------
function book_log_icon_error()   { book_log_color book_log_light_red "✖" "$@"; }
function book_log_text_error()   { book_log_color book_log_light_red "[ERROR]" "$@"; }


# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a question message.
# -------------------------------------------------------
function book_log_icon_question(){ book_log_color book_log_light_green "?" "${WHITE}$@${RESET}"; }
function book_log_text_question(){ book_log_color book_log_purple "[QUESTION]" "$@"; }


# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a section header with a bordered title and subtitle.
# -------------------------------------------------------
function book_log_section(){
  book_log_light_green "-------------------------------------------------------"
  echo -e " ${LIGHT_GREEN}===${RESET} ${WHITE}$1${RESET} ${LIGHT_GREEN}===${RESET}"
  echo
  if [[ -n "$2" ]]; then
    echo " $2"
    echo
  fi
}

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Logs a topic header with an arrow indicator.
# -------------------------------------------------------
function book_log_topic(){
  echo
  echo -e "${WHITE}➤  $1${RESET} "
  echo 
}

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Prompts a yes/no question and returns 0 for yes, 1 for no.
# -------------------------------------------------------
function book_log_question_yes_no() {
  local prompt="$1"
  echo -en "$(book_log_color book_log_light_green "?") ${WHITE}${prompt} ${DARK_GRAY}[y/N]${RESET} "
  read -r answer
  tput cuu1 && tput el

  case "$answer" in
    [yY][eE][sS]|[yY])
      echo -e "$(book_log_color book_log_light_green "?") ${WHITE}${prompt} ${LIGHT_BLUE}Yes${RESET}"
      return 0
      ;;
    *)
      echo -e "$(book_log_color book_log_light_green "?") ${WHITE}${prompt} ${LIGHT_BLUE}No${RESET}"
      return 1
      ;;
  esac
}

# -------------------------------------------------------
# Category    :: LOGGER
# Description :: Highlights a message with a green bordered book.
# -------------------------------------------------------
function book_log_highlight_message() {
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


# -------------------------------------------------------
# Category    :: CHECKBOX
# Description :: Displays a checkbox list menu to select and run multiple bash functions.
# -------------------------------------------------------
function book_set_checkbox_list() {
  local -n options_ref=$1
  local -n functions_ref=$2
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
    IFS= read -rsn1 key1 || break
    case "$key1" in
      $'\x1b')
        read -rsn2 key2
        case "$key2" in
          "[A") ((current--)); ((current < 0)) && current=$((${#options_ref[@]} - 1)) ;;
          "[B") ((current++)); ((current >= ${#options_ref[@]})) && current=0 ;;
        esac
        ;;
      " ")
        selected[current]=$((1 - selected[current]))
        ;;
      ""|$'\n'|$'\r')
        local has_any_selected=false
        for i in "${!selected[@]}"; do
          if [[ ${selected[i]} -eq 1 ]]; then
            has_any_selected=true
            break
          fi
        done
        if ! $has_any_selected; then
          selected[current]=1
        fi
        break
        ;;
    esac
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
  echo -e "${WHITE}> option selected: ${LIGHT_CYAN}$item_line${RESET}"


  if ! $any_selected; then
    echo -e "${WHITE}(No features selected)${RESET}"
    return
  fi


  for i in "${!options_ref[@]}"; do
    if [[ ${selected[i]} -eq 1 ]]; then
      local callback="${functions_ref[i]}"
      if declare -F "$callback" > /dev/null; then
        book_log_icon_info "Running: ${LIGHT_CYAN}${options_ref[i]} ${DARK_GRAY}($callback)${RESET}"
        echo
        "$callback"
      else
        book_log_icon_warning "Function not found: ${WHITE}$callback${RESET}"
      fi
    fi
  done
}


# -------------------------------------------------------
# Category    :: LOADING
# Description :: Displays a rotating animation by shifting the characters in the input string linearly.
#                Useful for indicating progress during background tasks with a smooth terminal effect.
# -------------------------------------------------------
function book_linear_loading() {
    local input="$1"
    local repeat=3   
    local delay=0.1   

    export LC_ALL=C.UTF-8

    readarray -t chars < <(echo -n "$input" | grep -o .)
    local len=${#chars[@]}
    local frames=()

    for ((i=0; i<len; i++)); do
        local frame=""
        for ((j=0; j<len; j++)); do
            index=$(( (i + j) % len ))
            frame+="${chars[$index]}"
        done
        frames+=("$frame")
    done

    for ((j=0; j<repeat; j++)); do
        for frame in "${frames[@]}"; do
            echo -ne "\r$frame"
            sleep "$delay"
        done
    done
    echo
    echo 
}

# -------------------------------------------------------
# Category    :: LOADING
# Description :: Shows a "boomerang"-style loading animation by gradually expanding and shrinking
#                the input string. Clears the screen on each frame to enhance the motion effect.
# -------------------------------------------------------
function book_boomerang_loading() {
    local input="$1"
    local delay=0.05  
    export LC_ALL=C.UTF-8

    readarray -t chars < <(echo -n "$input" | grep -o .)
    local len=${#chars[@]}
    local frames=()

    for ((i=1; i<=len; i++)); do
        frame=""
        for ((j=0; j<i; j++)); do
            frame+="${chars[$j]}"
        done
        frames+=("$frame")
    done

    for ((i=len-1; i>0; i--)); do
        frame=""
        for ((j=0; j<i; j++)); do
            frame+="${chars[$j]}"
        done
        frames+=("$frame")
    done

    local repeat=3        

    for ((r=0; r<repeat; r++)); do
        for frame in "${frames[@]}"; do
            clear
            echo "$frame"
            # sleep "$delay"
        done
    done
    echo
}


# -------------------------------------------------------
# Category    :: MENU
# Description :: Displays an interactive menu to execute bash functions using arrow keys and Enter.
# -------------------------------------------------------
function book_set_menu() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: book_set_menu <options_array_name> <functions_array_name>"
    exit 1
  fi

  local -n _options=$1
  local -n _functions=$2

  local esc=$(printf "\033")
  local selected=0

  while true; do
    echo
    for i in "${!_options[@]}"; do
      if [[ $i -eq $selected ]]; then
        book_log_light_cyan "> ${_options[$i]}"
      else
        echo "  ${_options[$i]}"
      fi
    done

    local quit_index=${#_options[@]}
    if [[ $selected -eq $quit_index ]]; then
      book_log_light_cyan "> Quit"
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
      local selected_function="${_functions[$selected]}"

      # echo "Option selected: $choice"

      if declare -F "$selected_function" > /dev/null; then
        "$selected_function"
      else
        echo "Error: Function not found: $selected_function"
      fi

      echo -e "\nPress any key to return to the menu..."
      read -rsn1
    fi

    tput cuu $(( ${#_options[@]} + 2 )) 
    tput ed
  done
}


# -------------------------------------------------------
# Category    :: STEP
# Description :: Displays a spinner while a background process runs, then logs success or error.
# -------------------------------------------------------
function book_spinner_step() {
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
    book_log_icon_success "${WHITE}$message${RESET}"
  else
    book_log_icon_error "${WHITE}$message${RESET}"
  fi

  return $exit_code
}

# -------------------------------------------------------
# Category    :: STEP
# Description :: Runs a function in the background with spinner and handles its output and errors.
# -------------------------------------------------------
function book_run_step() {
  local cmd="$1"
  local message="$2"

  if ! declare -f "$cmd" > /dev/null; then
    book_log_icon_error "Error: '$cmd' is not a valid function."
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

  book_spinner_step $pid "$message"
  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    echo
    book_log_icon_error "Error output:"
    cat "$stderr_file"
    echo
  fi

  rm -f "$stdout_file" "$stderr_file"

  return $exit_code
}


# -------------------------------------------------------
# Category    :: TABLE
# Description :: Prints a formatted table with a header and rows, using fixed column width.
# -------------------------------------------------------
function book_show_table() {
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
function book_show_table_with_borders()  {
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



VT_SUCCESS_COUNT=0
VT_ERROR_COUNT=0
VT_SUCCESS_LIST=()
VT_ERROR_LIST=()

# -------------------------------------------------------
# Category    :: VALIDATIONS
# Description :: Checks if a tool exists and runs a success command if found.
#                Registers the result for summary reporting.
# -------------------------------------------------------
function book_has_tool() {
  local tool_name="$1"
  local success_cmd="$2"

  local tool_path
  tool_path=$(command -v "$tool_name" 2>/dev/null)
  book_log_icon_info "$tool_name: ${DARK_GRAY}($success_cmd)${RESET}"

  if [ -n "$tool_path" ]; then
    book_log_icon_success "$tool_name installed"
    echo
    if [[ "$success_cmd" == *"%s"* ]]; then
      eval "$(printf "$success_cmd" "$tool_path")"
    else
      eval "$success_cmd"
    fi
    VT_SUCCESS_COUNT=$((VT_SUCCESS_COUNT + 1))
    VT_SUCCESS_LIST+=("$tool_name")
  else
    book_log_icon_error "$tool_name not found"
    VT_ERROR_COUNT=$((VT_ERROR_COUNT + 1))
    VT_ERROR_LIST+=("$tool_name")
  fi

  book_log_dark_gray "--------------"
}

# -------------------------------------------------------
# Category    :: VALIDATIONS
# Description :: Displays a summary of tool validation results, listing
#                successes and failures in a clear format.
# -------------------------------------------------------
function book_summary_tool_validation() {
  HEADER="Versions checked|Successes|Errors"
  ROWS=(
    "$((VT_SUCCESS_COUNT + VT_ERROR_COUNT))|$VT_SUCCESS_COUNT|$VT_ERROR_COUNT"
  )
  book_show_table_with_borders "$HEADER" "${ROWS[@]}"
  echo
  if [ ${#VT_SUCCESS_LIST[@]} -gt 0 ]; then
    book_log_icon_success "${WHITE}Successful tools${RESET}:"
    for tool in "${VT_SUCCESS_LIST[@]}"; do
      book_log_light_green "  - $tool"
    done
    echo
  fi

  if [ ${#VT_ERROR_LIST[@]} -gt 0 ]; then
    book_log_icon_error "${WHITE}Error tools${RESET}:"
    for tool in "${VT_ERROR_LIST[@]}"; do
      book_log_light_red "  - $tool"
    done
    echo
  fi
}



A=(
"   ░███    "
"  ░██░██   "
" ░██  ░██  "
"░█████████ "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"           "
"           "
"           "
"           "
)

a=(
"           "
"           "
" ░██████   "
"      ░██  "
" ░███████  "
"░██   ░██  "
" ░█████░██ "
"           "
"           "
"           "
"           "
)

B=(
"░████████   "
"░██    ░██  "
"░██    ░██  "
"░████████   "
"░██     ░██ "
"░██     ░██ "
"░█████████  "
"            "
"            "
"            "
"            "
)

b=(
"░██        "
"░██        "
"░████████  "
"░██    ░██ "
"░██    ░██ "
"░███   ░██ "
"░██░█████  "
"           "
"           "
"           "
"           "
)

C=(
"  ░██████  "
" ░██   ░██ "
"░██        "
"░██        "
"░██        "
" ░██   ░██ "
"  ░██████  "
"           "
"           "
"           "
"           "
)

c=(
"           "
"           "
" ░███████  "
"░██    ░██ "
"░██        "
"░██    ░██ "
" ░███████  "
"           "
"           "
"           "
"           "
)

D=(
"░███████   "
"░██   ░██  "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"░██   ░██  "
"░███████   "
"           "
"           "
"           "
"           "
)
        
d=(
"       ░██ "
"       ░██ "
" ░████████ "
"░██    ░██ "
"░██    ░██ "
"░██   ░███ "
" ░█████░██ "
"           "
"           "
"           "
"           "
)

E=(
"░██████████ "
"░██         "
"░██         "
"░█████████  "
"░██         "
"░██         "
"░██████████ "
"            "
"            "
"            "
"            "
)

e=(
"           "
"           "
" ░███████  "
"░██    ░██ "
"░█████████ "
"░██        "
" ░███████  "
"           "
"           "
"           "
"           "
)

F=(
"░██████████"
"░██        "
"░██        "
"░█████████ "
"░██        "
"░██        "
"░██        "
"           "
"           "
"           "
"           "
)

f=(
"    ░████ "
"   ░██    "
"░████████ "
"   ░██    "
"   ░██    "
"   ░██    "
"   ░██    "
"          "
"          "
"          "
"          "
)
G=(
"  ░██████  "
" ░██   ░██ "
"░██        "
"░██  █████ "
"░██     ██ "
" ░██  ░███ "
"  ░█████░█ "
"           "
"           "
"           "
"           "
)

g=(
"           "
"           "
" ░████████ "
"░██    ░██ "
"░██    ░██ "
"░██   ░███ "
" ░█████░██ "
"       ░██ "
" ░███████  "
"           "
"           "
"           "
"           "
"           "
)
H=(
"░██     ░██ "
"░██     ░██ "
"░██     ░██ "
"░██████████ "
"░██     ░██ "
"░██     ░██ "
"░██     ░██ "
"            "
"            "
"            "
"            "
)

h=(
"░██        "
"░██        "
"░████████  "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"           "
"           "
"           "
"           "
)

I=(
"░██████   "
"  ░██     "
"  ░██     "
"  ░██     "
"  ░██     "
"  ░██     "
"░██████   "
"          "
"          "
"          "
"          "
)

i=(
"░██      "
"         "
"░██      "
"░██      "
"░██      "
"░██      "
"░██      "
"         "
"         "
"         "
"         "
)

j=(
"  ░██    "
"         "
"  ░██    "
"  ░██    "
"  ░██    "
"  ░██    "
"  ░██    "
"  ░██    "
"░███     "
"         "
"         "
"         "
"         "
)

J=(
"    ░█████ "
"      ░██  "
"      ░██  "
"      ░██  "
"░██   ░██  "
"░██   ░██  "
" ░██████   "
"           "
"           "
"           "
"           "
)

k=(
"░██        "
"░██        "
"░██    ░██ "
"░██   ░██  "
"░███████   "
"░██   ░██  "
"░██    ░██ "
"           "
"           "
"           "
"           "
)

K=(
"░██     ░██ "
"░██    ░██  "
"░██   ░██   "
"░███████    "
"░██   ░██   "
"░██    ░██  "
"░██     ░██ "
"            "
"            "
"            "
"            "
)

l=(
"░██ "
"░██ "
"░██ "
"░██ "
"░██ "
"░██ "
"░██ "
"    "
"    "
"    "
"    "
)

L=(
"░██         "
"░██         "
"░██         "
"░██         "
"░██         "
"░██         "
"░██████████ "
"            "
"            "
"            "
"            "
)

M=(
"░███     ░███ "
"░████   ░████ "
"░██░██ ░██░██ "
"░██ ░████ ░██ "
"░██  ░██  ░██ "
"░██       ░██ "
"░██       ░██ "
"              "
"              "
"              "
"              "
)

m=(
"                "
"                "
"░█████████████  "
"░██   ░██   ░██ "
"░██   ░██   ░██ "
"░██   ░██   ░██ "
"░██   ░██   ░██ "
"                "
"                "
"                "
"                "
)

N=(
"           "
"           "
"░████████  "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"           "
"           "
"           "
"           "
)

n=(
"░███    ░██ "
"░████   ░██ "
"░██░██  ░██ "
"░██ ░██ ░██ "
"░██  ░██░██ "
"░██   ░████ "
"░██    ░███ "
"            "
"            "
"            "
"            "
)


O=(
"  ░██████   "
" ░██   ░██  "
"░██     ░██ "
"░██     ░██ "
"░██     ░██ "
" ░██   ░██  "
"  ░██████   "
"            "
"            "
"            "
"            "
)

o=(
"           "
"           "
" ░███████  "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
" ░███████  "
"           "
"           "
"           "
"           "
)

P=(
"░█████████  "
"░██     ░██ "
"░██     ░██ "
"░█████████  "
"░██         "
"░██         "
"░██         "
"            "
"            "
"            "
"            "
)

p=(
"           "
"           "
"░████████  "
"░██    ░██ "
"░██    ░██ "
"░███   ░██ "
"░██░█████  "
"░██        "
"░██        "
"           "
"           "
"           "
"           "
"           "
)


q=(
"           "
"           "
" ░████████ "
"░██    ░██ "
"░██    ░██ "
"░██   ░███ "
" ░█████░██ "
"       ░██ "
"       ░██ "
"           "
"           "
"           "
"           "
"           "
)

Q=(
"  ░██████   "
" ░██   ░██  "
"░██     ░██ "
"░██     ░██ "
"░██     ░██ "
" ░██   ░██  "
"  ░██████   "
"       ░██  "
"        ░██ "
"            "
"            "
"            "
"            "
)

R=(
"░█████████  "
"░██     ░██ "
"░██     ░██ "
"░█████████  "
"░██   ░██   "
"░██    ░██  "
"░██     ░██ "
"            "
"            "
"            "
"            "
)

r=(
"         "
"         "
"░██░████ "
"░███     "
"░██      "
"░██      "
"░██      "
"         "
"         "
"         "
"         "
)

S=(
"  ░██████   "
" ░██   ░██  "
"░██         "
" ░████████  "
"        ░██ "
" ░██   ░██  "
"  ░██████   "
"            "
"            "
"            "
"            "
)

s=(
"           "
"           "
" ░███████  "
"░██        "
" ░███████  "
"       ░██ "
" ░███████  "
"           "
"           "
"           "
"           "
)



T=(
"░██████████"
"    ░██    "
"    ░██    "
"    ░██    "
"    ░██    "
"    ░██    "
"    ░██    "
"           "
"           "
"           "
"           "
)

t=(
"   ░██    "
"   ░██    "
"░████████ "
"   ░██    "
"   ░██    "
"   ░██    "
"    ░████ "
"          "
"          "
"          "
"          "
)

u=(
"           "
"           "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"░██   ░███ "
" ░█████░██ "
"           "
"           "
"           "
"           "
)

U=(
"░██     ░██ "
"░██     ░██ "
"░██     ░██ "
"░██     ░██ "
"░██     ░██ "
" ░██   ░██  "
"  ░██████   "
"            "
"            "
"            "
"            "
)

V=(
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
" ░██  ░██  "
"  ░██░██   "
"   ░███    "
"           "
"           "
"           "
"           "
)


v=(
"           "
"           "
"░██    ░██ "
"░██    ░██ "
" ░██  ░██  "
"  ░██░██   "
"   ░███    "
"           "
"           "
"           "
"           "
)

w=(
"                  "
"                  "
"░██    ░██    ░██ "
"░██    ░██    ░██ "
" ░██  ░████  ░██  "
"  ░██░██ ░██░██   "
"   ░███   ░███    "
"                  "
"                  "
"                  "
"                  "
)

W=(
"░██       ░██ "
"░██       ░██ "
"░██  ░██  ░██ "
"░██ ░████ ░██ "
"░██░██ ░██░██ "
"░████   ░████ "
"░███     ░███ "
"            "
"            "
"            "
"            "
)

X=(
"░██    ░██ "
" ░██  ░██  "
"  ░██░██   "
"   ░███    "
"  ░██░██   "
" ░██  ░██  "
"░██    ░██ "
"            "
"            "
"            "
"            "
)

x=(
"           "
"           "
"░██    ░██ "
" ░██  ░██  "
"  ░█████   "
" ░██  ░██  "
"░██    ░██ "
"            "
"            "
"            "
"            "
)

y=(
"           "
"           "
"           "
"░██    ░██ "
"░██    ░██ "
"░██    ░██ "
"░██   ░███ "
" ░█████░██ "
"       ░██ "
" ░███████  "
"           "
"           "
"           "
"           "
"           "
)

Y=(
"░██     ░██ "
" ░██   ░██  "
"  ░██ ░██   "
"   ░████    "
"    ░██     "
"    ░██     "
"    ░██     "
"            "
"            "
"            "
"            "

)

Z=(
"░█████████ "
"      ░██  "
"     ░██   "
"   ░███    "
"  ░██      "
" ░██       "
"░█████████ "
"           "
"           "
"           "
"           "
)

z=(
"           "
"           "
"░█████████ "
"     ░███  "
"   ░███    "
" ░███      "
"░█████████ "
"           "
"           "
"           "
"           "
)


# -------------------------------------------------------
# Category    :: FONT
# Description :: Displays a stylized ASCII art title for 
#                a given word by printing each letter line by 
#                line using predefined font patterns.
# -------------------------------------------------------
function book_show_script_title() {
    local word=$1
    local lines=10
    local i j letter line temp
    echo
    echo
    for ((i=0; i<lines; i++)); do
        line=""
        for ((j=0; j<${#word}; j++)); do
            letter="${word:j:1}"
            eval "temp=\${${letter}[$i]}"
            line+="$temp  "
        done
        echo "$line"
    done
}
