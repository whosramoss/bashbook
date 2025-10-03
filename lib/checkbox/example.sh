#!/bin/bash

source "lib/logger/main.sh"
source "lib/checkbox/main.sh"

sdx_log_section "Show Checkbox Functions" \
  "Interactive shell function for multi-select checkbox menus that runs corresponding scripts on confirmation." 


options=(
  "Option 1 "
  "Option 2"
)

scripts=(
  "lib/checkbox/example-option1.sh"
  "lib/checkbox/example-option2.sh"
)

header_msg="${LIGHT_GREEN}? ${WHITE}Choose options above?${RESET} ${DARK_GRAY}(Use ↑ ↓ to navigate, space to select, enter to confirm)${RESET}"

sdx_set_checkbox_list options scripts "$header_msg"
