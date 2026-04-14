# This tutorial is for Debian!
- This tutorial was made in Debian 12 (Bookworm)
- This tutorial is expected to work with previous versions of Debian (such as Debian 11, Bullseye)
- Unfortunately, this tutorial is not functional on Debian 13 (Trixie)

## Note
Please apply the addsomedistro patch from the parent directory first beforehand!
and replace all "debian" in the commands with "debookworm" or "debullseye" to point out the Debian versions that are supported with this tutorial.

Currently working on a workaround supporting Debian 13!

## Installing Debian
Use the following command to install the latest stable release of Debian:
```
proot-distro install debian
```

## Logging in to Debian
Use the following command to login to Debian as root:
```
proot-distro login debian
```
Install necessary packages:
```
apt update -y
apt install sudo nano adduser -y
```
Create a user account:
```
adduser hitominikki
```
Grant user sudo privileges:
```
nano /etc/sudoers
```
then scroll down until you can find "root ALL=(ALL:ALL) ALL"
and add "hitominikki ALL=(ALL:ALL) ALL" below the "root ALL=(ALL:ALL) ALL"
> [!NOTE]
> You are free to replace "hitominikki" to your desired username but must replace the "hitominikki" mentioned above in this tutorial to your desired username.

## Logging in to Debian with a user
Use the following command to login Debian as a user:
```
proot-distro login debian --user hitominikki
```
> [!NOTE]
> or replace "hitominikki" with your desired username.

### Install a desktop environment
> [!NOTE]
> This tutorial is compatible with: GNOME,  XFCE4, KDE Plasma, Cinnamon, MATE, LXDE, LXQt, Sugar, WindowMaker, Enlightenment, and FVWM Crystal.

Use the following command to install the packages for the desktop environment:
  
```
sudo apt install xfce4
```
> [!NOTE]
> desire other desktop environment? replace "xfce4" with...
> * `gnome`: dbus-x11 nano gnome gnome-shell gnome-terminal gnome-tweaks gnome-software nautilus gnome-shell-extension-manager gedit tigervnc-tools gnupg2
> * `kde_plasma`: kde-plasma-desktop
> * `cinnamon`: cinnamon
> * `mate`: mate-desktop-environment
> * `lxde`: lxde
> * `lxqt`: lxqt
> * `sugar`: sugar-session
> * `enlightenment`: enlightenment
> * `windowmaker`: wmaker
> * `fvwm_crystal`: fvwm_crystal

> if you desided to download gnome, please use this command after gnome is installed:
```
for file in $(find /usr -type f -iname "*login1*"); do rm -rf $file
done
```
## Boot into desktop environment
> [!NOTE]
> This took me a while but thanks to LinuxDroidMaster's Termux-Desktops Repository got this one optimized!

> At this point onward, please logout!
Use the following command to add a convenient way to login:
```
nano startxfce.sh
```
> [!NOTE]
> the filename "startxfce.sh" is not strict and could be called any filename.

in the GNU nano text editor please type:

for all desktop environments BUT GNOME:
```
kill -9 $(pgrep -f "termux.x11") 2>/dev/null
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 >/dev/null &
sleep 3
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 1
proot-distro login debian --shared-tmp -- /bin/bash -c  'export PULSE_SERVER=127.0.0.1 && export XDG_RUNTIME_DIR=${TMPDIR} && su - hitominikki -c "env DISPLAY=:0 startxfce4"'
exit 0
```
for GNOME:
```
kill -9 $(pgrep -f "termux.x11") 2>/dev/null
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 >/dev/null &
sleep 3
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 1
proot-distro login debian --shared-tmp -- /bin/bash -c  'export PULSE_SERVER=127.0.0.1 && export XDG_RUNTIME_DIR=${TMPDIR} && sudo service dbus start && su - hitominikki -c "env DISPLAY=:0 gnome-shell --x11"'
exit 0
```
> or replace "hitominikki" with your desired username!

> and if you are using other desktop environment, replace "startxfce4" with..
> * `kde_plasma`: startplasma-x11
> * `cinnamon`: cinnamon-session
> * `mate`: mate-session
> * `lxde`: startlxde
> * `lxqt`: startlxqt
> * `sugar`: sugar
> * `enlightenment`: enlightenment_start
> * `windowmaker`: startwmaker
> * `fvwm_crystal`: fvwm_crystal

Grant the sh file execute permission:
```
chmod +x startxfce.sh
```
> [!NOTE]
> or replace "startxfce.sh" with desired filename.

To start desktop environment, please use this command every time:
```
./startxfce.sh
```
> [!NOTE]
> or replace "startxfce.sh" with desired filename
