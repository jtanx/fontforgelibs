#!/bin/bash

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKAGES=(
    mingw-w64-libspiro-git
    mingw-w64-libuninameslist-git
    mingw-w64-xorg-util-macros-git
    mingw-w64-x11proto-git
    mingw-w64-renderproto-git
    mingw-w64-kbproto-git
    mingw-w64-inputproto-git
    mingw-w64-xextproto-git
    mingw-w64-xf86bigfontproto-git
    mingw-w64-xcb-proto-git
    mingw-w64-libxau-git
    mingw-w64-xtrans-git
    mingw-w64-libxcb-git
    mingw-w64-libx11-git
    mingw-w64-libxext-git
    mingw-w64-libxrender-git
    mingw-w64-libxft-git
    
    #mingw-w64-cairo-x11
    #mingw-w64-pango-x11
)

# Colourful text
# Red text
function log_error() {
    echo -e "\e[31m$@\e[0m"
}

# Yellow text
function log_status() {
    echo -e "\e[33m$@\e[0m"
}

# Green text
function log_note() {
    echo -e "\e[32m$@\e[0m"
}

function bail () {
    echo -e "\e[31m\e[1m!!! Build failed at: ${@}\e[0m"
    exit 1
}

for dir in ${PACKAGES[*]}; do
    if [ ! -d $dir ]; then
        bail "$dir doesn't exist"
    else
        log_note "Building $dir"
        cd $dir
        makepkg-mingw -sLfci --noconfirm  || bail "Failed to build $dir"
        cd $BASE
    fi
done