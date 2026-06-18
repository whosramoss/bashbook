#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 1_git_details.sh 
# Description :: Get Config Git details
# Compatible with: Linux · Windows
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

if ! book_is_linux && ! book_is_windows; then
  echo "Unsupported operating system"
  exit 1
fi

book_log_section "Git Configuration" ""

if command -v git &>/dev/null; then
  book_log_yellow "Version:" "$(git --version | awk '{print $3}')"
  book_log_yellow "User Name:" "$(git config user.name 2>/dev/null || echo 'Not configured')"
  book_log_yellow "User Email:" "$(git config user.email 2>/dev/null || echo 'Not configured')"
else
  book_log_icon_error "Git not found"
  exit 1
fi

book_log_section "Git Repository Status" ""

if git rev-parse --git-dir >/dev/null 2>&1; then
  book_log_yellow "Current Branch:" "$(git branch --show-current 2>/dev/null || echo 'N/A')"
  book_log_yellow "Repository Root:" "$(git rev-parse --show-toplevel 2>/dev/null || echo 'N/A')"
  
  if git remote &>/dev/null; then
    book_log_yellow "Remote Origin:" "$(git remote get-url origin 2>/dev/null || echo 'No remote configured')"
  fi
  
  if git log --oneline -n 1 &>/dev/null; then
    book_log_yellow "Latest Commit:" "$(git log -1 --oneline 2>/dev/null || echo 'No commits')"
  fi
else
  book_log_icon_warning "Current directory is not a Git repository"
fi

book_log_section "Git Global Configuration" ""

if git config --list --global &>/dev/null; then
  book_log_yellow "Core Editor:" "$(git config core.editor 2>/dev/null || echo 'Not configured')"
  book_log_yellow "Default Branch:" "$(git config init.defaultBranch 2>/dev/null || echo 'master')"
  book_log_yellow "GPG Signing:" "$(git config commit.gpgsign 2>/dev/null || echo 'false')"
  book_log_yellow "Auto CRLF:" "$(git config core.autocrlf 2>/dev/null || echo 'false')"
else
  book_log_icon_info "No global Git configuration found"
fi
