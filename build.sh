#!/bin/bash
# To update all the pkgvers without building:
# for f in mingw-w64*git; do pushd $f; makepkg-mingw -o --noprepare; popd; done
#
# To manually sign packages:
# for fn in *.xz; do gpg --detach-sign --no-armor $fn; done
#
# To update repo databases:
# repo-add --verify --sign --new --remove ./fontforgelibs32.db.tar.xz *.xz
# repo-add --verify --sign --new --remove ./fontforgelibs64.db.tar.xz *.xz
#
# To update SourceForge:
# cd into folder containing repo
# rsync -avP --delete ./ username@frs.sourceforge.net:/home/pfs/p/fontforgebuilds/build-system-extras/fontforgelibs/i686
# rsync -avP --delete ./ username@frs.sourceforge.net:/home/pfs/p/fontforgebuilds/build-system-extras/fontforgelibs/x86_64
# USE WITH CARE
#
# To add repo:
# Append to /etc/pacman.conf:
# [fontforgelibs32]
# Server = http://downloads.sourceforge.net/project/fontforgebuilds/build-system-extras/fontforgelibs/i686
#
# [fontforgelibs64]
# Server = http://downloads.sourceforge.net/project/fontforgebuilds/build-system-extras/fontforgelibs/x86_64
#
# Add signature to key chain:
# pacman-key -r 90F90C4A
# pacman-key --lsign-key 90F90C4A


BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKAGES=(
    mingw-w64-libspiro-git
    mingw-w64-libuninameslist-git
    #mingw-w64-xorg-util-macros-git
    #mingw-w64-x11proto-git
    #mingw-w64-renderproto-git
    #mingw-w64-kbproto-git
    #mingw-w64-inputproto-git
    #mingw-w64-xextproto-git
    #mingw-w64-xf86bigfontproto-git
    #mingw-w64-xcb-proto-git
    #mingw-w64-libxau-git
    #mingw-w64-xtrans-git
    #mingw-w64-libxcb-git
    #mingw-w64-libx11-git
    #mingw-w64-libxext-git
    #mingw-w64-libxrender-git
    #mingw-w64-libxft-git
    #mingw-w64-cairo-x11
    #mingw-w64-pango-x11
)

# Colourful text
# Red text
function log_error() {
    echo -ne "\e[31m"; echo "$@"; echo -ne "\e[0m"
}

# Yellow text
function log_status() {
    echo -ne "\e[33m"; echo "$@"; echo -ne "\e[0m"
}

# Green text
function log_note() {
    echo -ne "\e[32m"; echo "$@"; echo -ne "\e[0m"
}

function bail () {
    echo -ne "\e[31m\e[1m"; echo "!!! Build failed at: ${@}"; echo -ne "\e[0m"
    exit 1
}

for dir in ${PACKAGES[*]}; do
    cd $BASE
    
    if [ ! -d $dir ]; then
        bail "$dir doesn't exist"
    else
        log_note "Building $dir"
        cd $dir
        
        source PKGBUILD
        if [[ $pkgname == *"-git" ]]; then
            remotever=`git ls-remote $url master | cut -c 1-7`
            gitver=${pkgver##*.}
            
            #if [ "$gitver" != "$remotever" ]; then
            if true; then
                log_status "Updating ${_realname} ($remotever...$gitver)..."
            else
                log_status "${_realname} is up to date, skipping..."
                continue
            fi
        fi
        makepkg-mingw -sLfci --noconfirm --noprogressbar || bail "Failed to build $dir"
        #pacman -U --force --noconfirm *any.pkg.tar.xz
    fi
done

log_note "Done."