#!/bin/bash
source "lib/logger/main.sh"

FILENAME="shelldx.sh"

echo 
sdx_log_icon_info "Building ${LIGHT_GREEN}$FILENAME${RESET} by concatenating all main.sh files from lib/, placing logger first and removing duplicate headers and source commands..."
echo 

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

output_file="$SCRIPT_DIR/../$FILENAME"

CURRENT_DATE=$(date +"%d %B %Y %H:%M")


> "$output_file"

cat << EOF >> "$output_file"
#            ░██                   ░██ ░██        ░██            
#            ░██                   ░██ ░██        ░██            
#  ░███████  ░████████   ░███████  ░██ ░██  ░████████ ░██    ░██ 
# ░██        ░██    ░██ ░██    ░██ ░██ ░██ ░██    ░██  ░██  ░██  
#  ░███████  ░██    ░██ ░█████████ ░██ ░██ ░██    ░██   ░█████   
#        ░██ ░██    ░██ ░██        ░██ ░██ ░██   ░███  ░██  ░██  
#  ░███████  ░██    ░██  ░███████  ░██ ░██  ░█████░██ ░██    ░██ 
#                                                               
#                                                               
# Category     :: Shell Script Library
# Author       :: Gabriel Ramos (https://github.com/whosramoss/shelldx)
# Last Updated :: $CURRENT_DATE
# Description  :: A comprehensive collection of reusable Bash functions designed to enhance the
#                 command-line interface. It provides a wide range of utilities for producing stylized
#                 and colored output, displaying interactive menus, and running background
#                 processes with spinners. The library includes structured logging functions
#                 and support for formatted tables, enabling developers to create more
#                 visually engaging and user-friendly scripts.
# Note         :: All commands and functions in this library are prefixed with 'sdx' to ensure
#                 consistent naming and to prevent conflicts with other shell utilities or scripts.

EOF

echo -e "\n#!/bin/bash\n" >> "$output_file"

add_cleaned_main_sh() {
    local file="$1"

    if [[ -f "$file" ]]; then
        sdx_log_icon_info "- ${WHITE}adding${RESET} $file"
        grep -vE '^\s*(source|\. )|^\s*#!' "$file" >> "$output_file"
    else
        sdx_log_icon_warning "- File not found: $file"
    fi
}

logger_file="$SCRIPT_DIR/../lib/logger/main.sh"
add_cleaned_main_sh "$logger_file"

for file in "$SCRIPT_DIR"/../lib/*/main.sh; do
    [[ "$file" == "$logger_file" ]] && continue
    add_cleaned_main_sh "$file"
done

echo
sdx_log_icon_success "- ${WHITE}Done${RESET}: '$output_file' has been created."
