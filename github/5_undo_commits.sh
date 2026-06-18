#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 5_undo_commits.sh
# Description :: Undo Git commits with merge and force push handling
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

book_log_section "Git Commit Undo Utility" ""

# Check if there are any commits
if ! git rev-parse HEAD >/dev/null 2>&1; then
  book_log_icon_error "No commits found in this repository"
  exit 1
fi

# Show current commit information
book_log_section "Current Repository Status" ""
book_log_yellow "Current Branch:" "$(git branch --show-current)"
book_log_yellow "Latest Commit:" "$(git log -1 --oneline)"

# Show recent commits for reference
book_log_section "Recent Commits" ""
git log --oneline -5

# Check if latest commit is a merge commit
IS_MERGE_COMMIT=false
if git rev-parse --verify HEAD^2 >/dev/null 2>&1; then
  IS_MERGE_COMMIT=true
  book_log_icon_warning "Latest commit is a MERGE COMMIT"
fi

book_log_section "Undo Options" ""

if $IS_MERGE_COMMIT; then
  book_log_yellow "Merge Commit Detected:" "Will use --hard flag automatically"
fi

# Interactive selection
book_log_icon_question "How many commits do you want to undo? (default: 1)"
read -r COMMIT_COUNT

if [[ -z "$COMMIT_COUNT" ]] || [[ ! "$COMMIT_COUNT" =~ ^[0-9]+$ ]]; then
  COMMIT_COUNT=1
fi

book_log_yellow "Commits to undo:" "$COMMIT_COUNT"

# Check if commits exist in remote
book_log_section "Remote Status Check" ""
REMOTE_NAME=$(git remote | head -1)
HAS_REMOTE=false
COMMITS_IN_REMOTE=false

if [[ -n "$REMOTE_NAME" ]]; then
  HAS_REMOTE=true
  book_log_yellow "Remote found:" "$REMOTE_NAME"
  
  # Check if current branch has upstream
  if git rev-parse --abbrev-ref @{u} >/dev/null 2>&1; then
    UPSTREAM=$(git rev-parse --abbrev-ref @{u})
    book_log_yellow "Upstream branch:" "$UPSTREAM"
    
    # Check if commits exist in remote
    if git merge-base --is-ancestor HEAD~$COMMIT_COUNT HEAD && git merge-base --is-ancestor HEAD $UPSTREAM 2>/dev/null; then
      COMMITS_IN_REMOTE=true
      book_log_icon_warning "Commits exist in remote - will require force push"
    else
      book_log_icon_info "Commits are local only"
    fi
  else
    book_log_icon_info "No upstream branch configured"
  fi
else
  book_log_icon_info "No remote repository configured"
fi

# Determine reset method
RESET_METHOD="--mixed"
if $IS_MERGE_COMMIT; then
  RESET_METHOD="--hard"
  book_log_icon_warning "Using --hard reset for merge commit"
fi

book_log_section "Reset Configuration" ""
book_log_yellow "Reset method:" "$RESET_METHOD"
book_log_yellow "Target:" "HEAD~$COMMIT_COUNT"

if $COMMITS_IN_REMOTE; then
  book_log_yellow "Force push required:" "Yes"
else
  book_log_yellow "Force push required:" "No"
fi

# Confirmation
book_log_section "Confirmation" ""
book_log_icon_warning "This operation will:"
book_log_light_cyan "  - Reset $COMMIT_COUNT commit(s)"
if [[ "$RESET_METHOD" == "--hard" ]]; then
  book_log_light_cyan "  - PERMANENTLY remove all changes (--hard)"
else
  book_log_light_cyan "  - Keep changes in working directory (--mixed)"
fi

if $COMMITS_IN_REMOTE; then
  book_log_light_cyan "  - Require force push to update remote"
fi

if ! book_log_question_yes_no "Do you want to proceed?"; then
  book_log_icon_info "Operation cancelled"
  exit 0
fi

# Perform the reset
book_log_section "Executing Reset" ""
book_log_icon_info "Resetting $COMMIT_COUNT commit(s) with $RESET_METHOD"

if git reset HEAD~$COMMIT_COUNT $RESET_METHOD; then
  book_log_icon_success "Local reset completed successfully"
else
  book_log_icon_error "Failed to reset commits"
  exit 1
fi

# Show status after reset
book_log_yellow "New HEAD:" "$(git log -1 --oneline)"

if [[ "$RESET_METHOD" == "--mixed" ]]; then
  # Show working directory status
  if [[ -n "$(git status --porcelain)" ]]; then
    book_log_icon_info "Changes are now in working directory:"
    git status --short
  fi
fi

# Handle force push if needed
if $COMMITS_IN_REMOTE && $HAS_REMOTE; then
  book_log_section "Remote Update Required" ""
  book_log_icon_warning "Commits existed in remote repository"
  
  if book_log_question_yes_no "Do you want to force push to update remote?"; then
    book_log_icon_info "Performing force push to $REMOTE_NAME"
    
    if git push -f "$REMOTE_NAME" "$(git branch --show-current)"; then
      book_log_icon_success "Force push completed successfully"
    else
      book_log_icon_error "Force push failed"
      book_log_icon_info "You can manually force push with:"
      book_log_light_cyan "  git push -f $REMOTE_NAME $(git branch --show-current)"
    fi
  else
    book_log_icon_info "Skipped force push. Manual push required:"
    book_log_light_cyan "  git push -f $REMOTE_NAME $(git branch --show-current)"
  fi
fi

book_log_section "Operation Complete" ""
book_log_icon_success "Commit undo completed"
book_log_yellow "Commits undone:" "$COMMIT_COUNT"
book_log_yellow "Reset method:" "$RESET_METHOD"

if $IS_MERGE_COMMIT; then
  book_log_icon_info "Merge commit was successfully undone"
fi

# Show final repository status
book_log_section "Final Status" ""
book_log_yellow "Current HEAD:" "$(git log -1 --oneline)"
book_log_yellow "Working directory:" "$(if [[ -n "$(git status --porcelain)" ]]; then echo "Has changes"; else echo "Clean"; fi)"
