#!/data/data/com.termux/files/usr/bin/bash

# Định nghĩa các màu sắc
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[0m')"
C="$(printf '\033[1;36m')"

# Hàm hiển thị banner
banner() {
    clear
    printf "\033[33mTERMUX GNOME\033[0m\n"
    echo "${C}${BOLD} Install Gnome Desktop In Ubuntu"${W}
    echo "${C}${BOLD} by nduyy"${W}
    echo                                                   
}

# Cài đặt và kiểm tra các gói
package_install_and_check() {
    packs_list=($@)
    for package_name in "${packs_list[@]}"; do
        echo "${R}[${W}-${R}]${G}${BOLD} Installing package: ${C}$package_name ${W}"
        pkg install "$package_name" -y
        if [ $? -ne 0 ]; then
            apt --fix-broken install -y
            dpkg --configure -a
        fi
        if dpkg -s "$package_name" >/dev/null 2>&1; then
            echo "${R}[${W}-${R}]${G} $package_name installed successfully ${W}"
        else
            echo "${R}[${W}-${R}]${C} $package_name ${G}installation failed ${W}"
        fi
    done
}

# Cài đặt Ubuntu và GNOME
install_ubuntu_and_gnome() {
    banner
    echo "${R}[${W}-${R}]${G}${BOLD} Installing Ubuntu...${W}"
    proot-distro install ubuntu
    
    echo "${R}[${W}-${R}]${G}${BOLD} Logging into Ubuntu...${W}"
    proot-distro login ubuntu -- /bin/bash -c "
        echo '${R}[${W}-${R}]${G}${BOLD} Updating system...${W}'
        apt update -y && apt upgrade -y

        echo '${R}[${W}-${R}]${G}${BOLD} Installing GNOME Desktop...${W}'
        apt install ubuntu-gnome-desktop -y

        echo '${R}[${W}-${R}]${G}${BOLD} Installing VNC server...${W}'
        apt install tigervnc-standalone-server -y

        echo '${R}[${W}-${R}]${G}${BOLD} Configuring VNC server...${W}'
        vncserver

        # Tạo file xstartup cho VNC
        mkdir -p ~/.vnc
        echo '#!/bin/sh' > ~/.vnc/xstartup
        echo 'export XDG_SESSION_TYPE=x11' >> ~/.vnc/xstartup
        echo 'export XDG_CURRENT_DESKTOP=GNOME' >> ~/.vnc/xstartup
        echo 'gnome-session &' >> ~/.vnc/xstartup
        chmod +x ~/.vnc/xstartup

        echo '${R}[${W}-${R}]${G}${BOLD} GNOME Desktop installation completed!${W}'
        echo 'You can start the VNC server with: vncserver :1 -geometry 1920x1080'
    "
}

# Bắt đầu quá trình cài đặt
banner
package_install_and_check "proot proot-distro"
install_ubuntu_and_gnome
