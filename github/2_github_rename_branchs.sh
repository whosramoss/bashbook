#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 2_github_rename_branchs.sh  
# Description :: Rename branchs - local and remote
# Compatible with: Linux · Windows
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

if ! book_is_linux && ! book_is_windows; then
  echo "Unsupported operating system"
  exit 1
fi

if ! command -v git &>/dev/null; then
  book_log_icon_error "Git not found"
  exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  book_log_icon_error "Current directory is not a Git repository"
  exit 1
fi

book_log_section "Git Branch Rename Utility" ""

# Default values
OLD_NAME="feature/old"
NEW_NAME="feature/new" 
REMOTE="origin"

# Interactive input
book_log_icon_question "Enter old branch name" 
read -r OLD_NAME_INPUT
if [[ -n "$OLD_NAME_INPUT" ]]; then
  OLD_NAME="$OLD_NAME_INPUT"
fi

book_log_icon_question "Enter new branch name"
read -r NEW_NAME_INPUT
if [[ -n "$NEW_NAME_INPUT" ]]; then
  NEW_NAME="$NEW_NAME_INPUT"
fi

book_log_icon_question "Enter remote name (default: origin)"
read -r REMOTE_INPUT
if [[ -n "$REMOTE_INPUT" ]]; then
  REMOTE="$REMOTE_INPUT"
fi

book_log_section "Branch Rename Configuration" ""

book_log_yellow "Old Branch:" "$OLD_NAME"
book_log_yellow "New Branch:" "$NEW_NAME"
book_log_yellow "Remote:" "$REMOTE"

book_log_section "Executing Rename Operations" ""

# Check if old branch exists
if ! git show-ref --verify --quiet "refs/heads/$OLD_NAME"; then
  book_log_icon_error "Branch '$OLD_NAME' does not exist locally"
  exit 1
fi

# Rename local branch
book_log_icon_info "Renaming local branch from '$OLD_NAME' to '$NEW_NAME'"
if git branch -m "$OLD_NAME" "$NEW_NAME"; then
  book_log_icon_success "Local branch renamed successfully"
else
  book_log_icon_error "Failed to rename local branch"
  exit 1
fi

# Check if remote exists
if git remote get-url "$REMOTE" >/dev/null 2>&1; then
  # Delete old branch on remote
  book_log_icon_info "Deleting old branch '$OLD_NAME' on remote '$REMOTE'"
  if git push "$REMOTE" --delete "$OLD_NAME" 2>/dev/null; then
    book_log_icon_success "Old remote branch deleted"
  else
    book_log_icon_warning "Could not delete old remote branch (may not exist)"
  fi
  
  # Unset upstream for new branch
  book_log_icon_info "Unsetting upstream for new branch"
  git branch --unset-upstream "$NEW_NAME" 2>/dev/null || true
  
  # Push new branch to remote
  book_log_icon_info "Pushing new branch '$NEW_NAME' to remote '$REMOTE'"
  if git push "$REMOTE" -u "$NEW_NAME"; then
    book_log_icon_success "New branch pushed and upstream set"
  else
    book_log_icon_error "Failed to push new branch to remote"
    exit 1
  fi
else
  book_log_icon_warning "Remote '$REMOTE' not found. Local rename completed."
fi

book_log_section "Branch Rename Complete" ""
book_log_icon_success "Branch successfully renamed from '$OLD_NAME' to '$NEW_NAME'"
