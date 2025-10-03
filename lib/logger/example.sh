#!/bin/bash

source "lib/logger/main.sh"

sdx_log_section "Log Functions" \
  "A set of colored Bash logging functions with icons and labels for clear, user-friendly terminal output." 

sdx_log_black "Black" "(optional text)"
sdx_log_red "Red" "(optional text)"
sdx_log_green "Green" "(optional text)"
sdx_log_brown "Brown" "(optional text)"
sdx_log_blue "Blue" "(optional text)"
sdx_log_purple "Purple" "(optional text)"
sdx_log_cyan "Cyan" "(optional text)"
sdx_log_light_gray "Light Gray" "(optional text)"

sdx_log_dark_gray "Dark Gray" "(optional text)"
sdx_log_light_red "Light Red" "(optional text)"
sdx_log_light_green "Light Green" "(optional text)"
sdx_log_yellow "Yellow" "(optional text)"
sdx_log_light_blue "Light Blue" "(optional text)"
sdx_log_light_purple "Light Purple" "(optional text)"
sdx_log_light_cyan "Light Cyan" "(optional text)"
sdx_log_white "White" "(optional text)"

sdx_log_bg_black "Background Black" "(optional text)"
sdx_log_bg_red "Background Red" "(optional text)"
sdx_log_bg_green "Background Green" "(optional text)"
sdx_log_bg_brown "Background Brown" "(optional text)"
sdx_log_bg_blue "Background Blue" "(optional text)"
sdx_log_bg_purple "Background Purple" "(optional text)"
sdx_log_bg_cyan "Background Cyan" "(optional text)"
sdx_log_bg_gray "Background Gray" "(optional text)"

sdx_log_underline "Underline" "(optional text)"
sdx_log_blink "Blink" "(optional text)"
sdx_log_reverse "Reverse" "(optional text)"
sdx_log_concealed "Concealed" "(optional text)"
echo

sdx_log_topic "Example Logs Icons"
sdx_log_icon_info "Starting simulated process..."
sdx_log_icon_warning "Low disk space"
sdx_log_icon_error "Failed to connect to database"
sdx_log_icon_success "Process completed"
sdx_log_icon_question "Please select an option: ${DARK_GRAY}(Use arrow keys)${RESET}"
echo


sdx_log_topic "Example Logs Texts"
sdx_log_text_info "Connecting to local emulator..."
sdx_log_text_warning "Low disk space"
sdx_log_text_error "Failed to connect to database"
sdx_log_text_success "hosting: Local server: ${BOLD}http://localhost:5000${RESET}"
sdx_log_text_question "Please select an option: ${DARK_GRAY}(Use arrow keys)${RESET}"
echo

sdx_log_topic "Example Logs Highlight"
sdx_log_highlight_message "Highlight message"
echo

sdx_log_topic "Example Logs Question Yes/No"
if sdx_log_question_yes_no "Do you want to continue?"; then
  echo "Continuing..."
else
  echo "Operation canceled."
fi

