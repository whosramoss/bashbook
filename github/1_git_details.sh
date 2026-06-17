#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 1_git_details.sh 
# Description :: Get Config Git details
# Compatible with: Linux · Windows
# -------------------------------------------------------

# Git version
echo "[Git Version]"
git --version
echo

# Configured user name
echo "[User Name]"
git config user.name 2>/dev/null || echo "Not configured"
echo

# Configured email
echo "[User Email]"
git config user.email 2>/dev/null || echo "Not configured"
echo

# Git configuration
echo "[Git Configuration]"
git config --list 2>/dev/null
echo

# Check if current directory is a Git repository
if git rev-parse --git-dir >/dev/null 2>&1; then

    echo "[Current Branch]"
    git branch --show-current
    echo

    echo "[Remote Repositories]"
    git remote -v
    echo

    echo "[Latest Commit]"
    git log -1 --oneline
    echo

else
    echo "Current directory is not a Git repository."
fi
