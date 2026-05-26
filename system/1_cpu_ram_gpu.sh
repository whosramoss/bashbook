#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 1_cpu_ram_gpu  
# Description :: Displays CPU, RAM, and GPU information
# Compatible with: Linux · Windows
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

if ! book_is_linux && ! book_is_windows; then
  echo "Unsupported operating system"
  exit 1
fi

book_log_section "CPU — Processor" ""

if book_is_linux; then

  book_log_yellow "Model:" "$(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)"
  book_log_yellow "Cores:" "$(nproc)"
  book_log_yellow "Threads:" "$(grep -c '^processor' /proc/cpuinfo)"
  book_log_yellow "Frequency:" "$(grep 'cpu MHz' /proc/cpuinfo | head -1 | awk '{printf "%.0f MHz", $4}')"
  book_log_yellow "Architecture:" "$(uname -m)"

elif book_is_windows; then

  book_log_yellow "Model:" "$(powershell.exe -Command "(Get-CimInstance Win32_Processor).Name" | tr -d '\r')"
  book_log_yellow "Cores:" "$(powershell.exe -Command "(Get-CimInstance Win32_Processor).NumberOfCores" | tr -d '\r')"
  book_log_yellow "Threads:" "$(powershell.exe -Command "(Get-CimInstance Win32_Processor).NumberOfLogicalProcessors" | tr -d '\r')"
  book_log_yellow "Frequency:" "$(powershell.exe -Command "(Get-CimInstance Win32_Processor).MaxClockSpeed" | tr -d '\r') MHz"
  book_log_yellow "Architecture:" "$(powershell.exe -Command "(Get-CimInstance Win32_OperatingSystem).OSArchitecture" | tr -d '\r')"

fi

book_log_section "RAM — Memory" ""

if book_is_linux; then

  read -r mem_total mem_used mem_avail < <(free -h | awk 'NR==2{print $2,$3,$7}')
  book_log_yellow "Total:" "$mem_total"
  book_log_yellow "Used:" "$mem_used"
  book_log_yellow "Available:" "$mem_avail"

  TYPE=$(sudo dmidecode -t memory 2>/dev/null | grep -m1 'Type:' | awk '{print $2}')
  SPEED=$(sudo dmidecode -t memory 2>/dev/null | grep -m1 'Speed:' | awk '{print $2, $3}')

  book_log_yellow "Type:" "${TYPE:-N/A}"
  book_log_yellow "Frequency:" "${SPEED:-N/A}"

elif book_is_windows; then

  TOTAL=$(powershell.exe -Command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)" | tr -d '\r')

  book_log_yellow "Total:" "${TOTAL} GB"

  book_log_yellow "Type:" "$(powershell.exe -Command "(Get-CimInstance Win32_PhysicalMemory | Select-Object -First 1).SMBIOSMemoryType" | tr -d '\r')"

  book_log_yellow "Frequency:" "$(powershell.exe -Command "(Get-CimInstance Win32_PhysicalMemory | Select-Object -First 1).Speed" | tr -d '\r') MHz"

fi

book_log_section "GPU — Graphics Card" ""

if book_is_linux; then

  if command -v lspci &>/dev/null; then
    lspci | grep -E 'VGA|3D|Display' | while read -r line; do
      book_log_yellow "GPU:" "$line"
    done
  fi

  if command -v nvidia-smi &>/dev/null; then
    book_log_yellow "VRAM:" "$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -1) MB"
  fi

elif book_is_windows; then

  book_log_yellow "Model:" "$(powershell.exe -Command "(Get-CimInstance Win32_VideoController | Select-Object -First 1).Name" | tr -d '\r')"

  VRAM=$(powershell.exe -Command "[math]::Round((Get-CimInstance Win32_VideoController | Select-Object -First 1).AdapterRAM / 1MB)" | tr -d '\r')

  book_log_yellow "VRAM:" "${VRAM} MB"

fi

