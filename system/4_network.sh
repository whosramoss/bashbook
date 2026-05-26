#!/usr/bin/env bash

# -------------------------------------------------------
# FILE    :: 4_network  
# Description :: Displays network information -  Local IP · Public IP · Gateway · MAC · Wi-Fi · DNS
# Compatible with: Linux · Windows 
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bashbook/commands.sh
source "${SCRIPT_DIR}/../bashbook/commands.sh"

show_local_ips() {
  book_log_section "Local IP Addresses" ""

  if book_is_linux; then

    if command -v ip &>/dev/null; then

      while read -r iface family ip; do
        book_log_yellow "${iface}:" "${family} ${ip}"
      done < <(ip -o addr show 2>/dev/null | awk '
        {
          split($4, address, "/")
          print $2, $3, address[1]
        }
      ')

    else

      while read -r iface ip; do
        book_log_yellow "${iface}:" "IPv4 ${ip}"
      done < <(ifconfig 2>/dev/null | awk '
        /^[a-z]/ { iface=$1 }

        /inet / {
          print iface, $2
        }
      ')

    fi

  elif book_is_windows; then

    powershell.exe -Command "
      Get-NetIPAddress |
      Where-Object {
        \$_.IPAddress -notlike '127.*' -and
        \$_.AddressFamily -in ('IPv4','IPv6')
      } |
      Select-Object InterfaceAlias, AddressFamily, IPAddress |
      Format-Table -HideTableHeaders
    " | tr -d '\r'

  fi
}

show_public_ip() {
  book_log_section "Public IP Address" ""

  PUBLIC_IP=""

  for service in \
    "https://api.ipify.org" \
    "https://ifconfig.me/ip" \
    "https://icanhazip.com"
  do
    if command -v curl &>/dev/null; then
      PUBLIC_IP=$(curl -s --max-time 5 "$service" 2>/dev/null | tr -d '[:space:]')

    elif command -v wget &>/dev/null; then
      PUBLIC_IP=$(wget -qO- --timeout=5 "$service" 2>/dev/null | tr -d '[:space:]')
    fi

    [ -n "$PUBLIC_IP" ] && break
  done

  book_log_yellow "Public IP:" "${PUBLIC_IP:-Unavailable}"
}

show_gateway() {
  book_log_section "Default Gateway" ""

  if book_is_linux; then

    if command -v ip &>/dev/null; then
      gateway=$(ip route show default 2>/dev/null | awk '/default/ {print $3; exit}')

    else
      gateway=$(route -n 2>/dev/null | awk '$4~/UG/ {print $2; exit}')
    fi

    book_log_yellow "Gateway:" "${gateway:-N/A}"

  elif book_is_windows; then

    gateway=$(powershell.exe -Command "
      (Get-NetRoute -DestinationPrefix '0.0.0.0/0' |
      Select-Object -First 1).NextHop
    " | tr -d '\r')

    book_log_yellow "Gateway:" "${gateway:-N/A}"

  fi
}

show_mac_addresses() {
  book_log_section "MAC Addresses" ""

  if book_is_linux; then

    if command -v ip &>/dev/null; then

      while read -r iface mac; do
        book_log_yellow "${iface}:" "$mac"
      done < <(ip link show 2>/dev/null | awk '
        /^[0-9]/ {
          split($2, iface, ":")
        }

        /link\/ether/ {
          print iface[1], $2
        }
      ')

    else

      while read -r iface mac; do
        book_log_yellow "${iface}:" "$mac"
      done < <(ifconfig 2>/dev/null | awk '
        /^[a-z]/ { iface=$1 }

        /ether|HWaddr/ {
          print iface, $NF
        }
      ')

    fi

  elif book_is_windows; then

    powershell.exe -Command "
      Get-NetAdapter |
      Select-Object Name, MacAddress, Status |
      Format-Table -HideTableHeaders
    " | tr -d '\r'

  fi
}

show_wifi_info() {
  book_log_section "Wi-Fi Information" ""

  if book_is_linux; then

    if command -v nmcli &>/dev/null; then

      ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)

      book_log_yellow "SSID:" "${ssid:-N/A}"

      nmcli dev wifi list 2>/dev/null | head -5

    elif command -v iwconfig &>/dev/null; then

      iwconfig 2>/dev/null | grep -E 'ESSID|Signal'

    else

      book_log_icon_warning "nmcli or wireless-tools not installed"

    fi

  elif book_is_windows; then

    powershell.exe -Command "
      netsh wlan show interfaces
    " | grep -E "SSID|Signal|Radio type|Channel" | tr -d '\r'

  fi
}

show_dns_servers() {
  book_log_section "DNS Servers" ""

  if book_is_linux; then

    if [ -f /etc/resolv.conf ]; then

      grep '^nameserver' /etc/resolv.conf | while read -r _ dns; do
        book_log_yellow "DNS:" "$dns"
      done

    fi

  elif book_is_windows; then

    powershell.exe -Command "
      Get-DnsClientServerAddress |
      Select-Object InterfaceAlias, ServerAddresses |
      Format-Table -HideTableHeaders
    " | tr -d '\r'

  fi
}

if ! book_is_linux && ! book_is_windows; then
  echo "Unsupported operating system"
  exit 1
fi

show_local_ips
show_public_ip
show_gateway
show_mac_addresses
show_wifi_info
show_dns_servers
