#!/bin/bash

# 1. CLEANUP (Wajib: Matikan sesi lama & hapus lock file)
pkill -9 termux-x11
pkill -9 pulseaudio
pkill -9 dbus-daemon
rm -rf $TMPDIR/.X11-unix
rm -rf $TMPDIR/.X0-lock

# 2. START SERVICES (Host Termux)
# Jalankan Termux-X11 di display :0
termux-x11 :0 >/dev/null 2>&1 &

# Jalankan Audio (Biar XFCE ada suara sistem & media)
pulseaudio --start --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 >/dev/null 2>&1

echo "[+] Menunggu XFCE X11 Siap (3 Detik)..."
sleep 3

# 3. MASUK KE DEBIAN & JALANKAN XFCE
# --shared-tmp itu wajib buat komunikasi X11
proot-distro login debian --shared-tmp --user h3rwthme -- bash -c "
    export DISPLAY=:0
    export PULSE_SERVER=127.0.0.1
    export XDG_RUNTIME_DIR=/tmp/runtime-h3rwthme
    mkdir -p \$XDG_RUNTIME_DIR
    chmod 700 \$XDG_RUNTIME_DIR
    
    # Akselerasi GPU Adreno 740 (Mesa Zink)
    export MESA_LOADER_DRIVER_OVERRIDE=zink
    export TU_DEBUG=zink
    
    # Fix Rendering Java & UI
    export _JAVA_AWT_WM_NONREPARENTING=1
    
    echo '[+] Memulai XFCE4 Desktop...'
    # Gunakan dbus-launch biar panel & desktop icon muncul bener
    dbus-launch --exit-with-session startxfce4
"
