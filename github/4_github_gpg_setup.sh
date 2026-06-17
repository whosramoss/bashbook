#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 4_github_gpg_setup.sh
# Description :: make a Github GPG Setup
# Compatible with: Linux · Windows
# -------------------------------------------------------

set -e

echo "=========================================="
echo " GitHub GPG Setup"
echo "=========================================="
echo

# Detect operating system

OS="$(uname -s)"

open_url() {
local url="$1"

```
case "$OS" in
    Linux*)
        command -v xdg-open >/dev/null 2>&1 && xdg-open "$url" >/dev/null 2>&1 &
        ;;
    Darwin*)
        open "$url"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        start "$url" >/dev/null 2>&1
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
    Darwin*)
        if command -v pbcopy >/dev/null 2>&1; then
            pbcopy < "$file"
            return 0
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        if command -v clip.exe >/dev/null 2>&1; then
            cat "$file" | clip.exe
            return 0
        fi
        ;;
esac

return 1
```

}

echo "Checking GPG..."

if ! command -v gpg >/dev/null 2>&1; then
echo
echo "ERROR: GPG was not found."
echo "Please install GPG before continuing."
exit 1
fi

echo "GPG found:"
gpg --version | head -n 1

echo
read -rp "Enter your full name: " NAME
read -rp "Enter your GitHub email: " EMAIL

echo
echo "Generating GPG key..."
echo

cat > /tmp/gpg-batch.txt <<EOF
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

gpg --batch --generate-key /tmp/gpg-batch.txt

rm -f /tmp/gpg-batch.txt

echo
echo "Locating generated key..."

KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$EMAIL" 
| grep '^sec' 
| sed 's|.*/||' 
| awk '{print $1}' 
| head -n 1)

if [ -z "$KEY_ID" ]; then
echo "Unable to determine KEY_ID."
exit 1
fi

echo
echo "KEY_ID: $KEY_ID"

PUBLIC_KEY_FILE="/tmp/github-gpg-public.key"

gpg --armor --export "$KEY_ID" > "$PUBLIC_KEY_FILE"

echo
echo "=========================================="
echo "PUBLIC GPG KEY"
echo "=========================================="
cat "$PUBLIC_KEY_FILE"
echo
echo "=========================================="

if copy_clipboard "$PUBLIC_KEY_FILE"; then
echo
echo "✓ Public key copied to clipboard."
else
echo
echo "Could not copy automatically."
fi

echo
echo "Configuring Git..."

git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
git config --global gpg.program gpg

echo
echo "Opening GitHub GPG settings page..."

open_url "https://github.com/settings/keys"

echo
echo "Steps:"
echo
echo "1. Click 'New GPG Key'"
echo "2. Paste the copied key"
echo "3. Save"
echo

read -rp "Press ENTER after adding the key to GitHub..."

echo
echo "Verifying configuration..."
echo

git config --global user.signingkey
git config --global commit.gpgsign

echo
echo "=========================================="
echo "Setup completed successfully."
echo "KEY_ID: $KEY_ID"
echo "=========================================="
