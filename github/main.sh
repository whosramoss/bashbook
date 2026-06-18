#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: main.sh
# Description :: Main script to run all GitHub scripts
# Compatible with: Linux · Windows
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

chmod +x *.sh

book_show_script_title "GITHUB"

./1_git_details.sh
./2_rename_branchs.sh
./3_setup_github_ssh.sh
./4_github_gpg_setup.sh
./5_undo_commits.sh
