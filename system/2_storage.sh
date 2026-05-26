#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 2_storage  
# Description :: Displays storage information -  Disks · Partitions · Space · File Systems
# Compatible with: Linux · Windows 
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

if ! book_is_linux && ! book_is_windows; then
  echo "Unsupported operating system"
  exit 1
fi

book_log_section "Disks" ""

if book_is_linux; then

  if command -v lsblk &>/dev/null; then
    echo ""

    lsblk -d -o NAME,SIZE,ROTA,TRAN,MODEL 2>/dev/null | awk '
      NR==1 {
        printf "  %-10s %-8s %-5s %-8s %s\n",
        $1, $2, "Type", "Transport", $5
        next
      }

      {
        diskType=($3=="1")?"HDD":"SSD"

        printf "  %-10s %-8s %-5s %-8s %s\n",
        $1, $2, diskType, $4, $5
      }
    '
  fi

elif book_is_windows; then

  wmic diskdrive get Model,Size,MediaType /format:list 2>/dev/null | \
    grep -E 'Model=|Size=|MediaType=' | \
    paste - - - | \
    tr '\t' '\n' | \
    while read -r line; do

      book_log_yellow "$(echo "$line" | cut -d= -f1 | xargs):" \
        "$(echo "$line" | cut -d= -f2 | xargs)"

    done
fi

book_log_section "Partitions and Space" ""

if book_is_linux; then

  df -hT 2>/dev/null | awk '
    NR==1 {
      printf "  %-20s %-8s %-8s %-8s %-8s %s\n",
      $1, $2, $3, $4, $5, $7
      next
    }

    $2 !~ /tmpfs|devtmpfs|squashfs|overlay/ {
      printf "  %-20s %-8s %-8s %-8s %-8s %s\n",
      $1, $2, $3, $4, $5, $7
    }
  '

elif book_is_windows; then

  wmic logicaldisk get DeviceID,FileSystem,FreeSpace,Size,VolumeName /format:list 2>/dev/null | \
    grep -E 'DeviceID=|FileSystem=|FreeSpace=|Size=|VolumeName=' | \
    paste - - - - - | \
    while read -r line; do

      dev=$(echo "$line" | grep -o 'DeviceID=[^	]*' | cut -d= -f2)

      fs=$(echo "$line" | grep -o 'FileSystem=[^	]*' | cut -d= -f2)

      free=$(echo "$line" | grep -o 'FreeSpace=[^	]*' | cut -d= -f2 | \
        awk '{printf "%.1f GB", $1/1073741824}')

      size=$(echo "$line" | grep -o 'Size=[^	]*' | cut -d= -f2 | \
        awk '{printf "%.1f GB", $1/1073741824}')

      name=$(echo "$line" | grep -o 'VolumeName=[^	]*' | cut -d= -f2)

      book_log_yellow "${dev}:" "${name} | FS: ${fs} | Total: ${size} | Free: ${free}"
    done
fi

if book_is_linux; then

  book_log_section "Disk Type Details" ""

  for dev in /sys/block/sd* /sys/block/nvme* /sys/block/vd*; do
    [ -e "$dev" ] || continue

    name=$(basename "$dev")
    rotational=$(cat "$dev/queue/rotational" 2>/dev/null)

    if [ -d "/sys/block/$name" ] && echo "$name" | grep -q nvme; then
      diskType="NVMe SSD"

    elif [ "$rotational" = "0" ]; then
      diskType="SSD"

    else
      diskType="HDD"
    fi

    book_log_yellow "${name}:" "$diskType"
  done
fi
