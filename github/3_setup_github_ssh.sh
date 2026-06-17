#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 3_setup_github_ssh.sh
# Description :: make a Github SSH Setup
# Compatible with: Linux · Windows
# -------------------------------------------------------

set -e

echo "=========================================="
echo " GitHub SSH Setup"
echo "=========================================="
echo

# Detect operating system

OS="$(uname -s)"

open_url() {
local url="$1"

```
case "$OS" in
    Linux*)
        if command -v xdg-open >/dev/null 2>&1; then
            xdg-open "$url" >/dev/null 2>&1 &
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        start "$url" >/dev/null 2>&1
        ;;
    Darwin*)
        open "$url"
        ;;
esac
```

}

copy_clipboard() {
local file="$1"

```
case "$OS" in
    Linux*)
        if command -v xclip >/dev/null 2>&1; then
            xclip -selection clipboard < "$file"
            return 0
        elif command -v wl-copy >/dev/null 2>&1; then
            wl-copy < "$file"
            return 0
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        if command -v clip.exe >/dev/null 2>&1; then
            cat "$file" | clip.exe
            return 0
        fi
        ;;
    Darwin*)
        if command -v pbcopy >/dev/null 2>&1; then
            pbcopy < "$file"
            return 0
        fi
        ;;
esac

return 1
```

}

echo "Checking Git..."

if ! command -v git >/dev/null 2>&1; then
echo
echo "ERROR: Git was not found."
echo "Please install Git before continuing."
exit 1
fi

echo "Git found:"
git --version

echo
echo "Checking for existing SSH keys..."

SSH_DIR="$HOME/.ssh"

if [ -f "$SSH_DIR/id_ed25519" ] || 
[ -f "$SSH_DIR/id_ed25519.pub" ] || 
[ -f "$SSH_DIR/id_rsa" ] || 
[ -f "$SSH_DIR/id_rsa.pub" ]; then

```
echo
echo "An SSH key is already configured."
echo
echo "Files found:"
ls -1 "$SSH_DIR"
echo
echo "Process stopped to avoid overwriting existing keys."
exit 0
```

fi

echo
read -rp "Enter your GitHub email: " EMAIL

echo
echo "Generating SSH key..."

ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_DIR/id_ed25519" -N ""

echo
echo "Starting ssh-agent..."

eval "$(ssh-agent -s)"

echo
echo "Adding key to ssh-agent..."

ssh-add "$SSH_DIR/id_ed25519"

echo
echo "=========================================="
echo "PUBLIC KEY"
echo "=========================================="

cat "$SSH_DIR/id_ed25519.pub"

echo
echo "=========================================="

if copy_clipboard "$SSH_DIR/id_ed25519.pub"; then
echo
echo "✓ Key copied to clipboard."
else
echo
echo "Could not copy the key automatically."
fi

echo
echo "Opening GitHub SSH settings page..."

open_url "https://github.com/settings/keys"

echo
echo "Steps:"
echo
echo "1. Click 'New SSH Key'"
echo "2. Paste the copied key"
echo "3. Save"
echo

read -rp "Press ENTER after adding the key to GitHub..."

echo
echo "Testing GitHub connection..."
echo

ssh -T [git@github.com](mailto:git@github.com) || true

echo
echo "=========================================="
echo "Setup completed."
echo "=========================================="

