#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 5_system_health  
# Description :: Displays system health and performance -  Uptime · CPU · RAM · Processes · Startup · Updates
# Compatible with: Linux · Windows 
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

show_uptime_info() {
  book_log_section "System Uptime and Date" ""

  book_log_yellow "Current Date:" "$(date '+%Y-%m-%d %H:%M:%S')"
  book_log_yellow "Timezone:" "$(date '+%Z %z')"

  if book_is_linux; then

    book_log_yellow "Uptime:" "$(uptime -p 2>/dev/null || uptime)"

    boot=$(who -b 2>/dev/null | awk '{print $3, $4}')
    book_log_yellow "Last Boot:" "${boot:-N/A}"

  elif book_is_windows; then

    boot=$(powershell.exe -Command "
      (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    " | tr -d '\r')

    book_log_yellow "Last Boot:" "${boot:-N/A}"

    uptime=$(powershell.exe -Command "
      ((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime).ToString()
    " | tr -d '\r')

    book_log_yellow "Uptime:" "${uptime:-N/A}"

  fi
}

show_cpu_ram_usage() {
  book_log_section "CPU and RAM Usage" ""

  if book_is_linux; then

    cpu_idle=$(top -bn1 2>/dev/null | awk '
      /Cpu\(s\)/ {
        for(i=1;i<=NF;i++) {
          if($i ~ /id/) {
            gsub(/[^0-9.]/,"",$i)
            print $i
            break
          }
        }
      }
    ')

    cpu_used=$(awk "BEGIN { printf \"%.1f\", 100 - ${cpu_idle:-0} }")

    book_log_yellow "CPU Usage:" "${cpu_used}%"

    read -r ram_total ram_used ram_free < <(free -h 2>/dev/null | awk 'NR==2{print $2,$3,$4}')
    book_log_yellow "Total RAM:" "$ram_total"
    book_log_yellow "Used RAM:" "$ram_used"
    book_log_yellow "Free RAM:" "$ram_free"

  elif book_is_windows; then

    cpu=$(powershell.exe -Command "
      (Get-CimInstance Win32_Processor).LoadPercentage
    " | tr -d '\r')

    book_log_yellow "CPU Usage:" "${cpu}%"

    while IFS= read -r line; do
      book_log_light_gray "$line"
    done < <(powershell.exe -Command "
      \$os = Get-CimInstance Win32_OperatingSystem

      \$total = [math]::Round(\$os.TotalVisibleMemorySize / 1MB, 1)
      \$free  = [math]::Round(\$os.FreePhysicalMemory / 1MB, 1)
      \$used  = [math]::Round(\$total - \$free, 1)

      Write-Output \"Total RAM: \$total GB\"
      Write-Output \"Used RAM : \$used GB\"
      Write-Output \"Free RAM : \$free GB\"
    " | tr -d '\r')

  fi
}

show_top_processes() {
  book_log_section "Top Processes by CPU Usage" ""

  if book_is_linux; then

    echo ""

    ps aux --sort=-%cpu 2>/dev/null | awk '
      NR==1 {
        printf "  %-10s %-8s %-8s %s\n",
        "USER", "CPU%", "RAM%", "COMMAND"
      }

      NR>1 && NR<=11 {
        printf "  %-10s %-8s %-8s %s\n",
        $1, $3"%", $4"%", $11
      }
    '

  elif book_is_windows; then

    powershell.exe -Command "
      Get-Process |
      Sort-Object CPU -Descending |
      Select-Object -First 10 Name,
                                   CPU,
                                   @{Name='RAM_MB';Expression={[math]::Round(\$_.WorkingSet64 / 1MB,1)}} |
      Format-Table -HideTableHeaders
    " | tr -d '\r'

  fi
}

show_startup_programs() {
  book_log_section "Startup Programs" ""

  if book_is_linux; then

    if command -v systemctl &>/dev/null; then

      book_log_topic "Enabled Services"

      systemctl list-unit-files --state=enabled 2>/dev/null | \
        grep enabled | \
        head -10 | \
        awk '{printf "    %s\n", $1}'

    fi

    if [ -d ~/.config/autostart ]; then

      book_log_topic "User Autostart"

      ls ~/.config/autostart 2>/dev/null | while read -r item; do
        book_log_light_gray "  $item"
      done

    fi

  elif book_is_windows; then

    powershell.exe -Command "
      Get-CimInstance Win32_StartupCommand |
      Select-Object Name, Command |
      Format-Table -HideTableHeaders
    " | tr -d '\r'

  fi
}

show_system_updates() {
  book_log_section "System Updates" ""

  if book_is_linux; then

    if command -v apt &>/dev/null; then

      book_log_topic "Available Updates"

      apt list --upgradable 2>/dev/null | \
        grep -v Listing | \
        head -10

      count=$(apt list --upgradable 2>/dev/null | grep -c upgradable)

      book_log_yellow "Pending Packages:" "$count"

    elif command -v dnf &>/dev/null; then

      dnf check-update 2>/dev/null | head -10

    elif command -v pacman &>/dev/null; then

      pacman -Qu 2>/dev/null | head -10

    fi

  elif book_is_windows; then

    powershell.exe -Command "
      Get-HotFix |
      Sort-Object InstalledOn -Descending |
      Select-Object -First 10 HotFixID, InstalledOn |
      Format-Table -HideTableHeaders
    " | tr -d '\r'

  fi
}

if ! book_is_linux && ! book_is_windows; then
  echo "Unsupported operating system"
  exit 1
fi

show_uptime_info
show_cpu_ram_usage
show_top_processes
show_startup_programs
show_system_updates

