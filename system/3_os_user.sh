#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 3_os_user  
# Description :: Displays system and user information -  OS · Version · Build · User · Hostname · Serial · UUID
# Compatible with: Linux · Windows 
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

show_os_info() {
  book_log_section "Operating System" ""

  if book_is_linux; then

    if [ -f /etc/os-release ]; then
      . /etc/os-release

      book_log_yellow "Distribution:" "${PRETTY_NAME:-$NAME}"
      book_log_yellow "Version:" "${VERSION:-$VERSION_ID}"
    fi

    book_log_yellow "Kernel:" "$(uname -r)"
    book_log_yellow "Architecture:" "$(uname -m)"

    if uname -m | grep -qE "x86_64|aarch64"; then
      book_log_yellow "64 Bit:" "Yes"
    else
      book_log_yellow "64 Bit:" "No"
    fi

  elif book_is_windows; then

    book_log_yellow "Name:" "$(powershell.exe -Command "(Get-CimInstance Win32_OperatingSystem).Caption" | tr -d '\r')"

    book_log_yellow "Version:" "$(powershell.exe -Command "(Get-CimInstance Win32_OperatingSystem).Version" | tr -d '\r')"

    book_log_yellow "Build:" "$(powershell.exe -Command "(Get-CimInstance Win32_OperatingSystem).BuildNumber" | tr -d '\r')"

    book_log_yellow "Architecture:" "$(powershell.exe -Command "(Get-CimInstance Win32_OperatingSystem).OSArchitecture" | tr -d '\r')"

  fi
}

show_user_info() {
  book_log_section "User and Machine" ""

  book_log_yellow "User:" "$(whoami)"
  book_log_yellow "Hostname:" "$(hostname)"

  if book_is_linux; then

    book_log_yellow "UID:" "$(id -u)"

    book_log_yellow "Groups:" "$(id -Gn | tr ' ' ', ')"

    if groups | grep -qE "sudo|wheel|admin"; then
      book_log_yellow "Administrator:" "Yes"
    else
      book_log_yellow "Administrator:" "No"
    fi

    book_log_yellow "Shell:" "$SHELL"
    book_log_yellow "Home:" "$HOME"

  elif book_is_windows; then

    book_log_yellow "Domain:" "$(powershell.exe -Command "(Get-CimInstance Win32_ComputerSystem).Domain" | tr -d '\r')"

    isAdmin=$(powershell.exe -Command "
      \$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
      \$principal = New-Object Security.Principal.WindowsPrincipal(\$currentUser)
      \$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    " | tr -d '\r')

    book_log_yellow "Administrator:" "$isAdmin"

  fi
}

show_hardware_ids() {
  book_log_section "Hardware Identifiers" ""

  if book_is_linux; then

    if command -v dmidecode &>/dev/null; then

      serial=$(sudo dmidecode -s system-serial-number 2>/dev/null | xargs)
      uuid=$(sudo dmidecode -s system-uuid 2>/dev/null | xargs)
      vendor=$(sudo dmidecode -s system-manufacturer 2>/dev/null | xargs)

      book_log_yellow "Serial Number:" "${serial:-N/A}"
      book_log_yellow "UUID:" "${uuid:-N/A}"
      book_log_yellow "Vendor:" "${vendor:-N/A}"

    else

      uuid=$(cat /sys/class/dmi/id/product_uuid 2>/dev/null)

      book_log_yellow "UUID:" "${uuid:-N/A}"
      book_log_icon_warning "dmidecode is not installed"

    fi

  elif book_is_windows; then

    book_log_yellow "Serial Number:" "$(powershell.exe -Command "(Get-CimInstance Win32_BIOS).SerialNumber" | tr -d '\r')"

    book_log_yellow "UUID:" "$(powershell.exe -Command "(Get-CimInstance Win32_ComputerSystemProduct).UUID" | tr -d '\r')"

    book_log_yellow "Model:" "$(powershell.exe -Command "(Get-CimInstance Win32_ComputerSystemProduct).Name" | tr -d '\r')"

    book_log_yellow "Vendor:" "$(powershell.exe -Command "(Get-CimInstance Win32_ComputerSystemProduct).Vendor" | tr -d '\r')"

  fi
}

show_license_info() {
  book_log_section "Operating System License" ""

  if book_is_linux; then

    distro=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')

    book_log_yellow "License:" "Open Source / GNU GPL"
    book_log_yellow "Distribution:" "${distro:-Linux}"

  elif book_is_windows; then

    book_log_yellow "Product Key:" "$(powershell.exe -Command "(Get-CimInstance SoftwareLicensingService).OA3xOriginalProductKey" | tr -d '\r')"

  fi
}

if ! book_is_linux && ! book_is_windows; then
  echo "Unsupported operating system"
  exit 1
fi

show_os_info
show_user_info
show_hardware_ids
show_license_info
