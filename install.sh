#!/usr/bin/env bash

# ==============================
# Revogame Exclusive Control Panel
# ==============================

clear
printf "\033[3J\033[H\033[2J"

# Root Check
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root"
  exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'

# ==============================
# Logo
# ==============================

echo -e "${CYAN}"
cat << "EOF"
██████╗ ███████╗██╗   ██╗ ██████╗  ██████╗  █████╗ ███╗   ███╗███████╗
██╔══██╗██╔════╝██║   ██║██╔════╝ ██╔════╝ ██╔══██╗████╗ ████║██╔════╝
██████╔╝█████╗  ██║   ██║██║  ███╗██║  ███╗███████║██╔████╔██║█████╗
██╔══██╗██╔══╝  ╚██╗ ██╔╝██║   ██║██║   ██║██╔══██║██║╚██╔╝██║██╔══╝
██║  ██║███████╗ ╚████╔╝ ╚██████╔╝╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗
╚═╝  ╚═╝╚══════╝  ╚═══╝   ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
EOF
echo -e "${NC}"

echo -e "${WHITE}Exclusive Revogame Server Panel${NC}"
echo

# ==============================
# Functions
# ==============================

pause() {
  read -p "Press Enter to continue..."
}

# ==============================
# 1️⃣ GRE IPv4 Tunnel
# ==============================

gre_tunnel() {
  clear
  echo -e "${CYAN}=== GRE IPv4 Tunnel Setup ===${NC}"

  read -p "Local Server Public IP: " LOCAL_IP
  read -p "Remote Server Public IP: " REMOTE_IP
  read -p "Local Tunnel IP (e.g. 10.10.10.1/30): " LOCAL_TUN
  read -p "Remote Tunnel IP (e.g. 10.10.10.2): " REMOTE_TUN

  ip tunnel add gre1 mode gre local $LOCAL_IP remote $REMOTE_IP ttl 255
  ip addr add $LOCAL_TUN dev gre1
  ip link set gre1 up

  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  sysctl -p

  echo -e "${GREEN}GRE Tunnel Created Successfully ✔${NC}"
  pause
}

# ==============================
# 2️⃣ Speed Test by Ookla
# ==============================

speedtest_install() {
  clear
  echo -e "${CYAN}Installing Speedtest by Ookla...${NC}"

  curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash
  apt-get install -y speedtest

  echo -e "${GREEN}Installed Successfully ✔${NC}"
  echo
  speedtest
  pause
}

# ==============================
# 3️⃣ Smart DNS Changer
# ==============================

dns_changer() {
  clear
  echo -e "${CYAN}=== Smart DNS Changer ===${NC}"
  echo "1) Shecan"
  echo "2) Electro"
  echo "3) Begzar"
  echo "4) Google"
  echo "5) Cloudflare"
  echo

  read -p "Select DNS Provider: " dns

  case $dns in
    1)
      DNS1="178.22.122.100"
      DNS2="185.51.200.2"
      ;;
    2)
      DNS1="78.157.42.100"
      DNS2="78.157.42.101"
      ;;
    3)
      DNS1="185.55.226.26"
      DNS2="185.55.225.25"
      ;;
    4)
      DNS1="8.8.8.8"
      DNS2="8.8.4.4"
      ;;
    5)
      DNS1="1.1.1.1"
      DNS2="1.0.0.1"
      ;;
    *)
      echo "Invalid option"
      pause
      return
      ;;
  esac

  echo -e "nameserver $DNS1\nnameserver $DNS2" > /etc/resolv.conf

  echo -e "${GREEN}DNS Updated Successfully ✔${NC}"
  pause
}

# ==============================
# Main Menu
# ==============================

while true; do
  clear
  echo -e "${CYAN}==== Revogame Exclusive Panel ====${NC}"
  echo
  echo "1) GRE IPv4 Tunnel"
  echo "2) Speed Test By Ookla"
  echo "3) Smart DNS Changer"
  echo "0) Exit"
  echo

  read -p "Select Option: " option

  case $option in
    1) gre_tunnel ;;
    2) speedtest_install ;;
    3) dns_changer ;;
    0) clear; exit 0 ;;
    *) echo -e "${RED}Invalid Option${NC}"; sleep 1 ;;
  esac
done
