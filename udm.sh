#!/bin/bash
clear

echo -e "\e[1;36m=======================================================================\e[0m"
echo -e "\e[1;37m                 Unified Deployment Matrix (UDM) v1.011\e[0m"
echo -e "\e[1;36m=======================================================================\e[0m\n"

echo -e "\e[1;33mSelect Target Architecture to Deploy:\e[0m"
echo "  1) Manjaro Linux (DMX Base - Pacman)"
echo "  2) Debian Linux  (DDX Base - APT)"
echo "  3) Arch Linux    (DAX Base - Pacman)"
echo ""

while true; do
    read -p "Choice [1-3]: " OS_CHOICE
    case $OS_CHOICE in
        1) TARGET_OS="manjaro"; break ;;
        2) TARGET_OS="debian"; break ;;
        3) TARGET_OS="archlinux"; break ;;
        *) echo -e "\e[1;31m[!] Invalid selection. Please enter 1, 2, or 3.\e[0m" ;;
    esac
done

# =========================================================================
# SHARED TERMUX HOST LOGIC (Executes Once)
# =========================================================================
echo -e "\n\e[1;33m[i] Forcing primary Termux mirrors...\e[0m"
mkdir -p $PREFIX/etc/apt/sources.list.d
echo "deb https://packages.termux.dev/apt/termux-main stable main" > $PREFIX/etc/apt/sources.list
echo "deb https://packages.termux.dev/apt/termux-root root stable" > $PREFIX/etc/apt/sources.list.d/root.list
echo "deb https://packages.termux.dev/apt/termux-x11 x11 main" > $PREFIX/etc/apt/sources.list.d/x11.list

while true; do
    read -p "Username (lowercase letters/numbers only): " USER_NAME
    [[ "$USER_NAME" =~ ^[a-z_][a-z0-9_-]*$ ]] && break || echo -e "\e[1;31m[!] Invalid username.\e[0m"
done

while true; do
    read -s -p "Password (Min 8 chars): " USER_PASS; echo ""
    [ ${#USER_PASS} -lt 8 ] && { echo -e "\e[1;31m[!] Too short.\e[0m"; continue; }
    read -s -p "Confirm password: " P2; echo ""
    [[ "$USER_PASS" == "$P2" ]] && break || echo -e "\e[1;31m[!] Passwords do not match.\e[0m"
done

# =========================================================================
# OS SPECIFIC LOGIC (Branches based on target)
# =========================================================================

if [ "$TARGET_OS" == "manjaro" ]; then
    # --- MANJARO LOGIC ---
    PLASMA_MENU="echo \"  5) KDE Plasma 5\""
    PLASMA_CASE="5) EXEC_CMD='startplasma-x11'; break ;;"
    
    echo -e "\n\e[1;36m--- MANJARO DESKTOP ENVIRONMENT SELECTION ---\e[0m"
    ask_de() {
        read -p "Install $1? [y/N]: " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then ((DE_COUNT++)); OS_DE_LIST+=" $2"; if [[ "$1" == "XFCE" ]]; then XFCE_SELECTED="y"; fi; fi
    }
    while true; do
        DE_COUNT=0; OS_DE_LIST=""; XFCE_SELECTED="n"
        ask_de "XFCE" "xfce4 xfce4-goodies"
        ask_de "MATE" "mate mate-extra"
        ask_de "LXQt" "lxqt oxygen-icons"
        ask_de "LXDE" "lxde"
        ask_de "KDE Plasma 5" "plasma-meta konsole dolphin"
        if [ $DE_COUNT -gt 0 ]; then break; else echo -e "\e[1;31m[!] Error: Pick at least one.\e[0m"; fi
    done

    set -e
    echo -e "\n\e[1;33m[i] Preparing Manjaro Environment...\e[0m"
    apt update && apt upgrade -y; pkg install x11-repo root-repo tur-repo proot-distro termux-x11-nightly pulseaudio nano wget curl -y
    proot-distro remove manjaro 2>/dev/null || true; proot-distro install manjaro

cat << 'EOF_PAYLOAD' > payload.sh
#!/bin/bash
set -e
echo " -> Updating Arch Repositories..."
pacman-key --init && pacman-key --populate manjaro manjaro-arm archlinuxarm
pacman -Syu --noconfirm
echo " -> Installing Core Architecture..."
pacman -S --noconfirm sudo nano git wget curl base-devel dbus xorg-server-xvfb shared-mime-info gtk-update-icon-cache $3
echo " -> Securing User..."
useradd -m -s /bin/bash -G wheel "$1"; printf "%s:%s\n" "$1" "$2" | chpasswd
echo "$1 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
echo " -> Stabilizing GTK..."
mkdir -p /usr/lib/gdk-pixbuf-2.0/2.10.0
P=$(find /usr/bin /usr/lib -name gdk-pixbuf-query-loaders -type f -executable | head -n 1)
[ -n "$P" ] && "$P" > /usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
update-mime-database /usr/share/mime || true; gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
if [[ "$4" == "y" ]]; then
    mkdir -p /home/"$1"/.config/xfce4/xfconf/xfce-perchannel-xml/
    cat << 'EOF_XML' > /home/"$1"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?><channel name="xfwm4" version="1.0"><property name="general" type="empty"><property name="use_compositing" type="bool" value="false"/></property></channel>
EOF_XML
    chown -R "$1":"$1" /home/"$1"/.config
fi
EOF_PAYLOAD

elif [ "$TARGET_OS" == "debian" ]; then
    # --- DEBIAN LOGIC ---
    PLASMA_MENU="echo \"  5) KDE Plasma 5\""
    PLASMA_CASE="5) EXEC_CMD='startplasma-x11'; break ;;"

    echo -e "\n\e[1;36m--- DEBIAN DESKTOP ENVIRONMENT SELECTION ---\e[0m"
    ask_de() {
        read -p "Install $1? [y/N]: " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then ((DE_COUNT++)); OS_DE_LIST+=" $2"; if [[ "$1" == "XFCE" ]]; then XFCE_SELECTED="y"; fi; fi
    }
    while true; do
        DE_COUNT=0; OS_DE_LIST=""; XFCE_SELECTED="n"
        ask_de "XFCE" "xfce4 xfce4-goodies"
        ask_de "MATE" "mate-desktop-environment-core"
        ask_de "LXQt" "lxqt-core lxqt-sudo oxygen-icon-theme"
        ask_de "LXDE" "lxde"
        ask_de "KDE Plasma 5" "kde-plasma-desktop konsole dolphin"
        if [ $DE_COUNT -gt 0 ]; then break; else echo -e "\e[1;31m[!] Error: Pick at least one.\e[0m"; fi
    done

    set -e
    echo -e "\n\e[1;33m[i] Preparing Debian Environment...\e[0m"
    apt update && apt upgrade -y; pkg install x11-repo root-repo tur-repo proot-distro termux-x11-nightly pulseaudio nano wget curl -y
    proot-distro remove debian 2>/dev/null || true; proot-distro install debian

cat << 'EOF_PAYLOAD' > payload.sh
#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
export TZ=America/Los_Angeles
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

echo " -> Updating Debian Repositories..."
apt-get update && apt-get upgrade -y
echo " -> Installing Core Architecture..."
apt-get install -y sudo nano git wget curl build-essential dbus-x11 x11-xserver-utils shared-mime-info gtk-update-icon-cache $3
echo " -> Securing User..."
useradd -m -s /bin/bash -G sudo "$1"; printf "%s:%s\n" "$1" "$2" | chpasswd
echo "$1 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
echo " -> Stabilizing GTK..."
mkdir -p /usr/lib/aarch64-linux-gnu/gdk-pixbuf-2.0/2.10.0
P=$(find /usr/lib/aarch64-linux-gnu -name gdk-pixbuf-query-loaders -type f -executable | head -n 1)
[ -n "$P" ] && "$P" > /usr/lib/aarch64-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders.cache || true
update-mime-database /usr/share/mime || true; gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
if [[ "$4" == "y" ]]; then
    mkdir -p /home/"$1"/.config/xfce4/xfconf/xfce-perchannel-xml/
    cat << 'EOF_XML' > /home/"$1"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?><channel name="xfwm4" version="1.0"><property name="general" type="empty"><property name="use_compositing" type="bool" value="false"/></property></channel>
EOF_XML
    chown -R "$1":"$1" /home/"$1"/.config
fi
EOF_PAYLOAD

elif [ "$TARGET_OS" == "archlinux" ]; then
    # --- ARCH LINUX LOGIC ---
    PLASMA_MENU=""
    PLASMA_CASE=""

    echo ""
    while IFS= read -r line; do
        echo -e "\e[38;2;23;147;209m${line}\e[0m"
    done << 'EOF_LOGO'
           /\
          /  \
         /    \
        /      \
       /   ,,   \
      /   |  |   \
     /_-''    ''-_\
EOF_LOGO
    echo -e "\n\e[1;36m--- ARCH DESKTOP ENVIRONMENT SELECTION (Plasma Excluded) ---\e[0m"
    ask_de() {
        read -p "Install $1? [y/N]: " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then ((DE_COUNT++)); OS_DE_LIST+=" $2"; if [[ "$1" == "XFCE" ]]; then XFCE_SELECTED="y"; fi; fi
    }
    while true; do
        DE_COUNT=0; OS_DE_LIST=""; XFCE_SELECTED="n"
        ask_de "XFCE" "xfce4 xfce4-goodies"
        ask_de "MATE" "mate mate-extra"
        ask_de "LXQt" "lxqt oxygen-icons"
        ask_de "LXDE" "lxde"
        if [ $DE_COUNT -gt 0 ]; then break; else echo -e "\e[1;31m[!] Error: Pick at least one.\e[0m"; fi
    done

    set -e
    echo -e "\n\e[1;33m[i] Preparing Arch Environment...\e[0m"
    apt update && apt upgrade -y; pkg install x11-repo root-repo tur-repo proot-distro termux-x11-nightly pulseaudio nano wget curl -y
    proot-distro remove archlinux 2>/dev/null || true; proot-distro install archlinux

cat << 'EOF_PAYLOAD' > payload.sh
#!/bin/bash
set -e
echo " -> Updating Arch Repositories..."
pacman-key --init && pacman-key --populate archlinuxarm
pacman -Syu --noconfirm
echo " -> Installing Core Architecture..."
pacman -S --noconfirm sudo nano git wget curl base-devel dbus xorg-server-xvfb shared-mime-info gtk-update-icon-cache $3
echo " -> Securing User..."
useradd -m -s /bin/bash -G wheel "$1"; printf "%s:%s\n" "$1" "$2" | chpasswd
echo "$1 ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
echo " -> Stabilizing GTK..."
mkdir -p /usr/lib/gdk-pixbuf-2.0/2.10.0
P=$(find /usr/bin /usr/lib -name gdk-pixbuf-query-loaders -type f -executable | head -n 1)
[ -n "$P" ] && "$P" > /usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache || true
update-mime-database /usr/share/mime || true; gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
if [[ "$4" == "y" ]]; then
    mkdir -p /home/"$1"/.config/xfce4/xfconf/xfce-perchannel-xml/
    cat << 'EOF_XML' > /home/"$1"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?><channel name="xfwm4" version="1.0"><property name="general" type="empty"><property name="use_compositing" type="bool" value="false"/></property></channel>
EOF_XML
    chown -R "$1":"$1" /home/"$1"/.config
fi
EOF_PAYLOAD
fi

# =========================================================================
# SHARED CONTAINER EXECUTION & DYNAMIC LAUNCHER GENERATION
# =========================================================================
chmod +x payload.sh
echo -e "\e[1;33m[i] Executing Container Payload in $TARGET_OS...\e[0m"
proot-distro login "$TARGET_OS" --bind "$PWD:/mnt" -- /mnt/payload.sh "$USER_NAME" "$USER_PASS" "$OS_DE_LIST" "$XFCE_SELECTED"
rm payload.sh

# The dynamic SA.sh generator.
cat << EOF_SA > sa.sh
#!/bin/bash
clear
echo -e "\e[1;36m===================================================\e[0m"
echo -e "\e[1;37m   SA: Start OS Shell (\e[1;32m$TARGET_OS\e[1;37m)\e[0m"
echo -e "\e[1;36m===================================================\e[0m"

killall -9 termux-x11 pulseaudio 2>/dev/null || true
pulseaudio --start --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
am start -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1
XDG_RUNTIME_DIR=\${TMPDIR} termux-x11 :0 -ac &
sleep 3

TARGET_USER=\$(proot-distro login $TARGET_OS -- bash -c "ls /home | head -n 1")

echo -e "\n\e[1;33mSelect Desktop Environment:\e[0m"
echo "  1) XFCE"
echo "  2) MATE"
echo "  3) LXQt"
echo "  4) LXDE"
$PLASMA_MENU

while true; do 
    read -p "Choice: " DE_RUN
    case \$DE_RUN in 
        1) EXEC_CMD='startxfce4'; break ;; 
        2) EXEC_CMD='mate-session'; break ;; 
        3) EXEC_CMD='startlxqt'; break ;; 
        4) EXEC_CMD='startlxde'; break ;; 
        $PLASMA_CASE
        *) echo "Invalid." ;; 
    esac
done

proot-distro login $TARGET_OS --user "\$TARGET_USER" --shared-tmp -- bash -c "export DISPLAY=:0; export PULSE_SERVER=tcp:127.0.0.1; export XKB_CONFIG_ROOT=/usr/share/X11/xkb; export GALLIUM_DRIVER=llvmpipe; export SHELL=/bin/bash; dbus-run-session -- \$EXEC_CMD"
EOF_SA

chmod +x sa.sh
echo -e "\n\e[1;32m   SUCCESS! Architecture deployed. Run: ./sa.sh\e[0m"
