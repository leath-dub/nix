#!/bin/sh

set -e

if [ "$(id -u)" = "0" ]; then
    echo "ERROR: Do not run this script as root"
    exit 1
fi

# Config options
: ${consolefont:=ter-120n.psf.gz}

consume() {
    exec $* 2> /dev/null > /dev/null
}

log() {
    echo "INFO:" $@
}

(consume which doas) && alias sudo=doas

about() {
    echo "This script was written for alpine linux 3.18"
    echo "Tweaks may be needed for other systems"
}

if [ ! -d /etc/profile.d ]; then
    echo "/etc/profile.d not found"
    about
    exit 1
fi

log "Setting .rc as ENV in profile"

if [ -f /etc/profile.d/setup-rc.sh ]; then
    echo "** step already completed **"
else
    cat <<EOF | sudo tee -a /etc/profile.d/setup-rc.sh
export ENV=$HOME/.rc
EOF
fi

log "Enabling root prompt to be colored"

if [ -f /etc/profile.d/color_prompt.sh ]; then
    echo "** step already completed **"
else
    sudo ln -s /etc/profile.d/color_prompt.sh.disabled /etc/profile.d/color_prompt.sh
fi

log "Change to alpine edge"

if [ -f /etc/apk/repositories.old ]; then
    echo "** step already completed **"
else
    sudo mv /etc/apk/repositories /etc/apk/repositories.old
    cat <<EOF | sudo tee /etc/apk/repositories
https://eu.edge.kernel.org/alpine/edge/main
https://eu.edge.kernel.org/alpine/edge/community
https://eu.edge.kernel.org/alpine/edge/testing
EOF
fi

log "Updating the system"

sudo apk update
sudo apk upgrade

log "Adding packages"
sudo apk add gpm font-terminus doas-sudo-shim curl xz gcompat bash gdb brightnessctl brightnessctl-udev alsa-utils alsaconf xdotool xprop

# Alias is not needed anymore
unalias sudo

log "Enabling services"
sudo rc-update add gpm
sudo rc-service gpm start

log "Changing the font"
if [ -f /etc/conf.d/consolefont.old ]; then
    echo "** step already completed **"
else
    sudo cp /etc/conf.d/consolefont /etc/conf.d/consolefont.old
    sudo sed -i "s/default8x16\.psf\.gz/${consolefont}/" /etc/conf.d/consolefont
    sudo rc-update add consolefont boot
fi

log "Installing nix"

if [ -f /nix ]; then
    echo "** step already completed **"
else
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    . $HOME/.nix-profile/etc/profile.d/nix.sh
fi

log "Setting up gui"

sudo setup-xorg-base
sudo apk add sx kitty kitty-kitten sxhkd xcompmgr xwallpaper setxkbmap setxkbmap xrandr xclip xinput xf86-video-intel xf86-video-vesa xf86-video-fbdev xf86-input-libinput xf86-input-evdev xauth pciutils mesa-gl intel-media-driver mesa-va-gallium gst-libav gst-plugins-ugly ffmpeg

sudo addgroup $USER video
sudo addgroup $USER audio
sudo addgroup $USER input

log "Enabling uinput"

if grep -q uinput /etc/modules; then
    echo "** step already completed **"
else
    sudo cp /etc/modules /etc/modules.old
    ( cat /etc/modules.old && echo uinput ) | sudo tee /etc/modules
fi

log "Enabling unpriveleged poweroff and reboot"

sudo apk add elogind polkit-elogind greetd greetd-tuigreet
sudo rc-update add elogind
sudo rc-updatet add polkit

set +e
