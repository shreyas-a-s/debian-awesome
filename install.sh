#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "You must BE a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

# Get username, working directory, i3 vsersion, distro name & debian version
username=$(id -u -n 1000)
builddir=$(pwd)

# Updating system & installing programs
echo ""; echo "Doing a system update & Installing the required programs..."
apt update && apt upgrade -y
apt install fonts-powerline x11-utils x11-xserver-utils curl imagemagick pulseaudio pavucontrol i3 i3status lightdm slick-greeter xfce4-terminal stterm wget nitrogen python3-pip dmenu fonts-font-awesome xserver-xorg-video-intel xserver-xorg-input-libinput picom -y

# Change the current working directory
cd "$builddir" || exit

# Creating necessary directories
echo ""; echo "Making necessary directories..."
mkdir -p /etc/lightdm/
mkdir -p /home/"$username"/.config/picom/
mkdir -p /home/"$username"/Screenshots/

# Copy config files
echo ""; echo "Copying config files..."
cp dotfiles/picom.conf /home/"$username"/.config/picom/ # Picom Compositor config file
chown -R "$username":"$username" /home/"$username" #otherwise you need sudo privileges whenever you want to change some of these files

# i3 tweaks
. ./scripts/reboot-poweroff.sh # For configuring reboot-poweroff commands in i3 config

# Done
echo "Installation is now complete. Reboot your system for the changes to take place.
Remember, upon reboot no wallpaper will be set. Use the app Nitrogen > Preferences to set a wallpaper.
If you would like to set the one on login screen as the main wallpaper,
Type this command from a terminal:
nitrogen --set-zoom-fill /usr/share/backgrounds/garden.jpg --save

Also, there would a file called 'welcome-to-my-i3.md' in the home folder.
Open it with a text editor of your choice. You'll get a qucik rundown of some important keyboard-mouse shortcuts."
