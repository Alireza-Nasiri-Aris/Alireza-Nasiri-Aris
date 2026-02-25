#!/usr/bin/env bash

# ==============================
# Revogame CLI Framework
# ==============================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'

BASE_URL="https://revogame.ir/install.sh"

clear

# Logo
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

echo -e "${WHITE}OS:${NC} $(lsb_release -ds 2>/dev/null || grep PRETTY_NAME /etc/os-release | cut -d= -f2)"
echo

# ==============================
# Functions
# ==============================

install_script() {
    NAME=$1
    FILE=$2

    echo -e "${YELLOW}Installing $NAME...${NC}"

    curl -fsSL -o /usr/local/bin/$FILE.sh $BASE_URL/$FILE.sh

    if [ $? -ne 0 ]; then
        echo -e "${RED}Download failed!${NC}"
        return
    fi

    chmod +x /usr/local/bin/$FILE.sh

    echo -e "#!/bin/bash" > /usr/local/bin/$FILE
    echo "bash /usr/local/bin/$FILE.sh" >> /usr/local/bin/$FILE
    chmod +x /usr/local/bin/$FILE

    echo -e "${GREEN}$NAME installed successfully!${NC}"
}

remove_script() {
    FILE=$1
    rm -f /usr/local/bin/$FILE
    rm -f /usr/local/bin/$FILE.sh
    echo -e "${GREEN}Removed successfully.${NC}"
}

pause() {
    read -p "Press Enter to continue..."
}

# ==============================
# Menu Loop
# ==============================

while true; do
    clear
    echo -e "${CYAN}==== Revogame Control Panel ====${NC}"
    echo
    echo "1) Install Master Tunnel"
    echo "2) Install Speedtest"
    echo "3) Install DNS Changer"
    echo "4) Remove Master Tunnel"
    echo "0) Exit"
    echo

    read -p "Select an option: " option

    case $option in
        1)
            install_script "Master Tunnel" "mtunnel"
            pause
            ;;
        2)
            install_script "Speedtest" "speedtest"
            pause
            ;;
        3)
            install_script "DNS Changer" "dnschanger"
            pause
            ;;
        4)
            remove_script "mtunnel"
            pause
            ;;
        0)
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${NC}"
            sleep 1
            ;;
    esac
done
