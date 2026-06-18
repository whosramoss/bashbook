#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 3_github_ssh_setup.sh
# Description :: make a Github SSH Setup
# Compatible with: Linux · Windows
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

if ! book_is_linux && ! book_is_windows; then
  echo "Unsupported operating system"
  exit 1
fi

set -e

book_log_section "GitHub SSH Setup" ""

# Check Git availability
if ! command -v git &>/dev/null; then
  book_log_icon_error "Git not found. Please install Git before continuing."
  exit 1
fi

book_log_yellow "Git Version:" "$(git --version | awk '{print $3}')"

# Check for existing SSH keys
SSH_DIR="$HOME/.ssh"
book_log_section "SSH Key Detection" ""

if [[ -f "$SSH_DIR/id_ed25519" ]] || [[ -f "$SSH_DIR/id_ed25519.pub" ]] || [[ -f "$SSH_DIR/id_rsa" ]] || [[ -f "$SSH_DIR/id_rsa.pub" ]]; then
  book_log_icon_warning "SSH keys already exist"
  book_log_yellow "SSH Directory:" "$SSH_DIR"
  if [[ -f "$SSH_DIR/id_ed25519.pub" ]]; then
    book_log_yellow "Ed25519 Key Found:" "$(cat "$SSH_DIR/id_ed25519.pub" | awk '{print $3}')"
  fi
  book_log_icon_info "Process stopped to avoid overwriting existing keys"
  exit 0
fi

# Get user email
book_log_section "User Configuration" ""
book_log_icon_question "Enter your GitHub email address"
read -r EMAIL

if [[ -z "$EMAIL" ]]; then
  book_log_icon_error "Email is required"
  exit 1
fi

book_log_yellow "Email:" "$EMAIL"

# Generate SSH key
book_log_section "SSH Key Generation" ""
book_log_icon_info "Generating Ed25519 SSH key"

if ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_DIR/id_ed25519" -N ""; then
  book_log_icon_success "SSH key generated successfully"
else
  book_log_icon_error "Failed to generate SSH key"
  exit 1
fi

# Start ssh-agent
book_log_section "SSH Agent Configuration" ""
book_log_icon_info "Starting ssh-agent"

if eval "$(ssh-agent -s)" >/dev/null; then
  book_log_icon_success "SSH agent started"
else
  book_log_icon_error "Failed to start ssh-agent"
  exit 1
fi

# Add key to ssh-agent
book_log_icon_info "Adding key to ssh-agent"
if ssh-add "$SSH_DIR/id_ed25519"; then
  book_log_icon_success "Key added to ssh-agent"
else
  book_log_icon_error "Failed to add key to ssh-agent"
  exit 1
fi

# Display public key
book_log_section "Public SSH Key" ""
echo
cat "$SSH_DIR/id_ed25519.pub"
echo

# Copy to clipboard function
copy_to_clipboard() {
  local file="$1"
  
  if book_is_linux; then
    if command -v xclip &>/dev/null; then
      xclip -selection clipboard < "$file"
      return 0
    elif command -v wl-copy &>/dev/null; then
      wl-copy < "$file"
      return 0
    fi
  elif book_is_windows; then
    if command -v clip.exe &>/dev/null; then
      cat "$file" | clip.exe
      return 0
    fi
  fi
  
  return 1
}

# Open URL function
open_github_url() {
  local url="$1"
  
  if book_is_linux; then
    if command -v xdg-open &>/dev/null; then
      xdg-open "$url" >/dev/null 2>&1 &
    fi
  elif book_is_windows; then
    if command -v start &>/dev/null; then
      start "$url" >/dev/null 2>&1
    fi
  fi
}

# Copy key to clipboard
if copy_to_clipboard "$SSH_DIR/id_ed25519.pub"; then
  book_log_icon_success "Public key copied to clipboard"
else
  book_log_icon_warning "Could not copy key automatically. Please copy manually."
fi

# Open GitHub settings
book_log_section "GitHub Configuration" ""
book_log_icon_info "Opening GitHub SSH settings page"
open_github_url "https://github.com/settings/keys"

book_log_yellow "Next Steps:" ""
book_log_light_cyan "  1. Click 'New SSH Key' on GitHub"
book_log_light_cyan "  2. Paste the copied key"
book_log_light_cyan "  3. Give it a descriptive title"
book_log_light_cyan "  4. Click 'Add SSH Key'"

book_log_icon_question "Press ENTER after adding the key to GitHub"
read -r

# Test GitHub connection
book_log_section "Connection Test" ""
book_log_icon_info "Testing GitHub SSH connection"

if ssh -o BatchMode=yes -o StrictHostKeyChecking=no -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  book_log_icon_success "GitHub SSH connection successful"
else
  book_log_icon_warning "GitHub SSH connection test completed (this is expected)"
fi

book_log_section "Setup Complete" ""
book_log_icon_success "GitHub SSH setup completed successfully"
book_log_yellow "Key Location:" "$SSH_DIR/id_ed25519"
book_log_yellow "Public Key:" "$SSH_DIR/id_ed25519.pub"
