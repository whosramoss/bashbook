#!/bin/bash

source "lib/main.sh"

sdx_show_script_title "shelldx"

sdx_log_section "Project Setup" \
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry." 

sdx_log_icon_question "Please select an option: ${DARK_GRAY}(Use arrow keys)${RESET}"
                                    
options=(
    "View Logs Functions"
    "View Table Functions"
    "View Checkbox Functions"
    "View Step Functions"
    "View Validations Functions"
    "View Loading Functions"
    "Build shelldx file"
)

files=(
    "lib/logger/example.sh"
    "lib/table/example.sh"
    "lib/checkbox/example.sh"
    "lib/step/example.sh"
    "lib/validations/example.sh"
    "lib/loading/example.sh"
    "scripts/build.sh"
)

sdx_set_menu options files
