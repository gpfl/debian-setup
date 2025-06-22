# Update the repos
sudo apt update

# basic dependencies
sudo apt install -y curl git

# Install nix package manager
curl -L https://nixos.org/nix/install | sh
# activate nix in the environment
. /etc/profile.d/nix.sh

# --- ZRAM CONFIG
sudo apt install -y systemd-zram-generator

"    [zram0]
    zram-size = ram * 0.5
    compression-algorithm = zstd" >> /etc/systemd/zram-generator.conf

sudo systemctl daemon-reload
sudo systemctl start dev-zram0.swap
sudo systemctl enable dev-zram0.swap
# ---


# -- LY DISPLAY MANAGER CONFIG
sudo apt install -y ly seatd dbus-user-session

# append to ~/.bash_profile
"if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec dbus-run-session seatd-launch labwc
fi" >> ~/.bash_profile

# to enable it
sudo systemctl enable ly.service
# ----------

# --- LABWC WINDOW MANAGER CONFIG
sudo apt install -y labwc mako kanshi waybar swaybg
#!/bin/sh
"
#!/bin/sh
waybar &
mako &
kanshi &" >> ~/.config/labwc/autostart

chmod +x ~/.config/labwc/autostart
# ----

# install build essentials
sudo apt install -y build-essential

# Create folders in user directory
"XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOCUMENTS_DIR="$HOME/documents"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_PUBLICSHARE_DIR="$HOME/public"
XDG_TEMPLATES_DIR="$HOME/templates"
XDG_VIDEOS_DIR="$HOME/videos"" >> ~/.config/user-dirs.dirs

xdg-user-dirs-update

# Network file tools/system events
sudo apt install -y dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends

# thunar
sudo apt install -y thunar file-roller thunar-archive-plugin thunar-volman gvfs gvfs-backends

# kitty
sudo apt install -y kitty

# network manager
sudo apt install -y network-manager # (add to autostart: `nm-applet &`)
# nmtui (network manager text user interface)

# sound
sudo apt install -y alsa-utils

### PipeWire
sudo apt install -y pipewire-audio wireplumber volumeicon-alsa pavucontrol bluez blueman
## to enable it:
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
systemctl --user enable --now pipewire pipewire-pulse wireplumber
# (add to autostart: `volumeicon &`)
# (add to autostart: `blueman-applet &`)

# fonts
sudo apt install -y fonts-recommended fonts-ubuntu fonts-font-awesome font-terminus papirus-icon-theme

# exa
# replace ls command in .bashrc with
# alias ls='exa -al --long --header --color=always --group-directories-first'
sodo apt install -y exa

sudo apt install -y fastfetch
sudo apt install -y librewolf

# packages needed for window manager installation
sudo apt install -y rofi libnotify-bin unzip

# geany
sudo apt install -y geany

# multimedia
sudo apy install -y mpv brightnessctl # (look into gammastep for Wayland)
