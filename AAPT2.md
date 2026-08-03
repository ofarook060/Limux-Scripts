#!/bin/bash
# aapt2 binary path for Termux
android.aapt2FromMavenOverride=/data/data/com.termux/files/usr/bin/aapt2

ALL=(ALL) NOPASSWD: ALL
/data/data/com.termux/files/home/

sudo apt install mugshot
sudo apt install papirus-icon-theme moka-icon-theme
sudo apt install numix-gtk-theme
sudo apt install conky-all




npx skills@latest add expo/skills --skill '*'

du -h --max-depth=1  2>/dev/null | sort -hr

npx expo prebuild --clean

npx expo config --type public
npx expo run:android
git config --global user.name "ofarook060"
git config --global user.email "ofarook060@gmail.com"

alias fm="am start -a android.intent.action.VIEW -d "content://com.android.externalstorage.documents/root/primary""
alias deb="proot-distro login debian --shared-tmp"
alias tpad="ssh ofarook@192.168.100.180"



python -m venv .venv
source .venv/bin/activate

apt install glib tur-repo  mesa-utils libgl1-mesa-dri 



export ANDROID_HOME="$HOME/dev/android_sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools/"
export PATH="$PATH:$ANDROID_HOME/build-tools/"
export GRADLE_HOME="$HOME/dev/gradle-9.4.0"
export PATH="$PATH:$GRADLE_HOME/bin"

#export FLUTTER_SDK="$HOME/dev/flutter"
#export PATH="$PATH:$FLUTTER_SDK/bin"

termux-storage-get

