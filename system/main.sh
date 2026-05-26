#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: main.sh
# Description :: Main script to run all system scripts
# Compatible with: Linux · Windows
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

chmod +x *.sh

book_show_script_title "SYSTEM"

./1_cpu_ram_gpu.sh
./2_storage.sh
./3_os_user.sh
./4_network.sh
./5_system_health.sh    