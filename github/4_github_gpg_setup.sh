#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 4_github_gpg_setup.sh
# Description :: make a Github GPG Setup
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

book_log_section "GitHub GPG Setup" ""

# Check GPG availability
if ! command -v gpg &>/dev/null; then
  book_log_icon_error "GPG not found. Please install GPG before continuing."
  exit 1
fi

book_log_yellow "GPG Version:" "$(gpg --version | head -n 1 | awk '{print $3}')"

# Get user information
book_log_section "User Information" ""
book_log_icon_question "Enter your full name"
read -r NAME

book_log_icon_question "Enter your GitHub email"
read -r EMAIL

if [[ -z "$NAME" ]] || [[ -z "$EMAIL" ]]; then
  book_log_icon_error "Name and email are required"
  exit 1
fi

book_log_yellow "Full Name:" "$NAME"
book_log_yellow "Email:" "$EMAIL"

# Generate GPG key
book_log_section "GPG Key Generation" ""
book_log_icon_info "Generating 4096-bit RSA GPG key"

BATCH_FILE="/tmp/gpg-batch-$$.txt"
cat > "$BATCH_FILE" <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $NAME
Name-Email: $EMAIL
Expire-Date: 0
%no-protection
%commit
EOF

if gpg --batch --generate-key "$BATCH_FILE"; then
  book_log_icon_success "GPG key generated successfully"
else
  book_log_icon_error "Failed to generate GPG key"
  rm -f "$BATCH_FILE"
  exit 1
fi

rm -f "$BATCH_FILE"

# Locate generated key
book_log_section "Key Identification" ""
book_log_icon_info "Locating generated GPG key"

KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$EMAIL" | grep '^sec' | sed 's|.*/||' | awk '{print $1}' | head -n 1)

if [[ -z "$KEY_ID" ]]; then
  book_log_icon_error "Unable to determine GPG KEY_ID"
  exit 1
fi

book_log_yellow "GPG Key ID:" "$KEY_ID"

# Export public key
PUBLIC_KEY_FILE="/tmp/github-gpg-public-$$.key"
if gpg --armor --export "$KEY_ID" > "$PUBLIC_KEY_FILE"; then
  book_log_icon_success "Public key exported"
else
  book_log_icon_error "Failed to export public key"
  exit 1
fi

# Display public key
book_log_section "Public GPG Key" ""
echo
cat "$PUBLIC_KEY_FILE"
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
if copy_to_clipboard "$PUBLIC_KEY_FILE"; then
  book_log_icon_success "Public GPG key copied to clipboard"
else
  book_log_icon_warning "Could not copy key automatically. Please copy manually."
fi

# Configure Git
book_log_section "Git Configuration" ""
book_log_icon_info "Configuring Git to use GPG key"

if git config --global user.signingkey "$KEY_ID" && \
   git config --global commit.gpgsign true && \
   git config --global gpg.program gpg; then
  book_log_icon_success "Git GPG configuration completed"
else
  book_log_icon_error "Failed to configure Git GPG settings"
  exit 1
fi

book_log_yellow "Signing Key ID:" "$(git config --global user.signingkey)"
book_log_yellow "Auto-sign Commits:" "$(git config --global commit.gpgsign)"

# Open GitHub settings
book_log_section "GitHub Configuration" ""
book_log_icon_info "Opening GitHub GPG settings page"
open_github_url "https://github.com/settings/keys"

book_log_yellow "Next Steps:" ""
book_log_light_cyan "  1. Click 'New GPG Key' on GitHub"
book_log_light_cyan "  2. Paste the copied GPG public key"
book_log_light_cyan "  3. Click 'Add GPG Key'"

book_log_icon_question "Press ENTER after adding the GPG key to GitHub"
read -r

# Verify configuration
book_log_section "Configuration Verification" ""
book_log_icon_info "Verifying GPG setup"

book_log_yellow "GPG Key ID:" "$KEY_ID"
book_log_yellow "Git Signing Key:" "$(git config --global user.signingkey || echo 'Not set')"
book_log_yellow "Auto-sign Commits:" "$(git config --global commit.gpgsign || echo 'false')"
book_log_yellow "GPG Program:" "$(git config --global gpg.program || echo 'gpg')"

# Cleanup
rm -f "$PUBLIC_KEY_FILE"

book_log_section "Setup Complete" ""
book_log_icon_success "GitHub GPG setup completed successfully"
book_log_yellow "GPG Key ID:" "$KEY_ID"
book_log_icon_info "Your commits will now be signed automatically"
