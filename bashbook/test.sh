#!/bin/bash

source "./commands.sh"

book_log_section "Project Setup" \
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry." 

book_log_icon_question "Please select an option: ${DARK_GRAY}(Use arrow keys)${RESET}"
                                    
run_logs_example() {
    book_log_section "Log Functions" \
      "A set of colored Bash logging functions with icons and labels for clear, user-friendly terminal output."

    book_log_black "Black" "(optional text)"
    book_log_red "Red" "(optional text)"
    book_log_green "Green" "(optional text)"
    book_log_brown "Brown" "(optional text)"
    book_log_blue "Blue" "(optional text)"
    book_log_purple "Purple" "(optional text)"
    book_log_cyan "Cyan" "(optional text)"
    book_log_light_gray "Light Gray" "(optional text)"

    book_log_dark_gray "Dark Gray" "(optional text)"
    book_log_light_red "Light Red" "(optional text)"
    book_log_light_green "Light Green" "(optional text)"
    book_log_yellow "Yellow" "(optional text)"
    book_log_light_blue "Light Blue" "(optional text)"
    book_log_light_purple "Light Purple" "(optional text)"
    book_log_light_cyan "Light Cyan" "(optional text)"
    book_log_white "White" "(optional text)"

    book_log_bg_black "Background Black" "(optional text)"
    book_log_bg_red "Background Red" "(optional text)"
    book_log_bg_green "Background Green" "(optional text)"
    book_log_bg_brown "Background Brown" "(optional text)"
    book_log_bg_blue "Background Blue" "(optional text)"
    book_log_bg_purple "Background Purple" "(optional text)"
    book_log_bg_cyan "Background Cyan" "(optional text)"
    book_log_bg_gray "Background Gray" "(optional text)"

    echo

    book_log_topic "Example Logs Icons"
    book_log_icon_info "Starting simulated process..."
    book_log_icon_warning "Low disk space"
    book_log_icon_error "Failed to connect to database"
    book_log_icon_success "Process completed"
    book_log_icon_question "Please select an option: ${DARK_GRAY}(Use arrow keys)${RESET}"
    echo

    book_log_topic "Example Logs Texts"
    book_log_text_info "Connecting to local emulator..."
    book_log_text_warning "Low disk space"
    book_log_text_error "Failed to connect to database"
    book_log_text_success "hosting: Local server: ${BOLD}http://localhost:5000${RESET}"
    book_log_text_question "Please select an option: ${DARK_GRAY}(Use arrow keys)${RESET}"
    echo

    book_log_topic "Example Logs Highlight"
    book_log_highlight_message "Highlight message"
    echo

    book_log_topic "Example Logs Question Yes/No"
    if book_log_question_yes_no "Do you want to continue?"; then
      echo "Continuing..."
    else
      echo "Operation canceled."
    fi
}

run_table_example() {
    book_log_section "Table Functions" \
      "function to dynamically print formatted tables with any number of columns using customizable headers and rows"

    local header="Emulator|Host:Port|View in Emulator UI"
    local rows=(
      "Functions|localhost:5001|http://localhost:4000/functions"
      "Database|localhost:9000|http://localhost:4000/database"
      "Hosting|localhost:5000|n/a"
      "Pub/Sub|localhost:8085|n/a"
    )

    book_log_topic "Example Table simple"
    book_show_table "$header" "${rows[@]}"

    echo

    book_log_topic "Example Table with borders"
    book_show_table_with_borders "$header" "${rows[@]}"
}

run_checkbook_example() {
    book_log_section "Show Checkbook Functions" \
      "Interactive shell function for multi-select checkbook menus that runs corresponding bash functions on confirmation."

    local options=(
      "Option 1 "
      "Option 2"
    )

    run_example_option1() {
      echo "example option 1"
    }

    run_example_option2() {
      echo "example option 2"
    }

    local functions=(
      "run_example_option1"
      "run_example_option2"
    )

    local header_msg="${LIGHT_GREEN}? ${WHITE}Choose options above?${RESET} ${DARK_GRAY}(Use ↑ ↓ to navigate, space to select, enter to confirm)${RESET}"
    book_set_checkbook_list options functions "$header_msg"
}


run_step_example() {
    book_log_section "Step Functions" \
      "Utility script for running named steps with confirmation prompts and spinner feedback."

    local file="temporary.txt"

    local step1="step_wait_before_create"
    local step2="step_create_file"
    local step3="step_delete_file"

    step_wait_before_create() {
      sleep 3
    }

    step_create_file() {
      touch "$file"
      echo "File '$file' created."
      sleep 3
    }

    step_delete_file() {
      rm -f "$file"
      echo "File '$file' deleted."
      sleep 3
    }

    if book_log_question_yes_no "Do you want create files?"; then
      book_run_step "$step1" "1. Waiting 3 seconds before creating the file"
      book_run_step "$step2" "2. Creating the file"
      book_run_step "$step3" "3. Deleting the file"
    fi
}

run_validations_example() {
    book_log_section "Validations Functions" \
      "Validates the presence of CLI tools, runs version checks, and summarizes the results."

    book_has_tool "git" "git --version"
    book_has_tool "node" "node --version"
    book_has_tool "jq" "jq --version"
    book_has_tool "docker" "docker --version"
    book_has_tool "curl" "curl --version"
    book_summary_tool_validation
}

run_loading_example() {
    book_log_section "Loading Functions" \
      "Contains animated Bash loading effects designed for terminal feedback."

    echo
    book_log_topic "Example Linear Loading"
    book_linear_loading "▁▂▃▅▆▇▇▆▅▃▂▁"
    book_linear_loading "░▒▓█▓▒░"

    echo
    book_log_topic "Example Boomerang Loading"
    book_boomerang_loading "[============]"
    book_boomerang_loading " > > > > > "
    book_boomerang_loading "###########"
}

main() {
    local options=(
        "View Logs Functions"
        "View Table Functions"
        "View Checkbook Functions"
        "View Step Functions"
        "View Validations Functions"
        "View Loading Functions"
    )

    local functions=(
        "run_logs_example"
        "run_table_example"
        "run_checkbook_example"
        "run_step_example"
        "run_validations_example"
        "run_loading_example"
    )

    book_set_menu options functions
}

main
