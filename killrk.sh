#!/bin/bash

# azazel, best left as default

AZAZEL_INSTALL="/lib"

# end azazel


# jynx2 settings, again, best left as default

JYNX2_INSTALL="/XxJynx"

# end jyxn2

GREEN="\033[0;32m"
RED="\033[0;31m"
RESET_COLOR="\033[0m"

usage()
{
    printf "Usage: $0 [option]\n"
    printf "\tazazel -- removes the userland azazel rootkit\n"
    printf "\tjynx2 -- removes the similar (to azazel) userland rootkit\n\n"
}

azazel()
{
    printf "${GREEN}/+/${RESET_COLOR} removing azazel rootkit\n\n"

    if [ ! -f "$AZAZEL_INSTALL/libselinux.so" ]; then
        printf "${RED}/-/${RESET_COLOR} azazel shared object file not found in $AZAZEL_INSTALL/\n
        \tit was either installed elsewhere or azazel is not installed\n
        \texiting\n"
        exit
    fi

    printf "${GREEN}/+/${RESET_COLOR} shared object file was found in $AZAZEL_INSTALL/, azazel has been located\n
    \tcreating symbolic link to ld_preload file\n\n"

    ln -sf /etc/ld.so.preload /tmp/tmp_ld_preload

    printf "${GREEN}/+/${RESET_COLOR} symbolic link created, now removing the library\n"

    echo 0 > /tmp/tmp_ld_preload
    rm -rf /etc/ld.so.preload

    printf "${GREEN}/+/${RESET_COLOR} copying the shared object file to /tmp\n\n"

    cp $AZAZEL_INSTALL/libselinux.so /tmp/libselinux_azazel.so
    rm -rf $AZAZEL_INSTALL/libselinux.so /tmp/tmp_ld_preload

    printf "${GREEN}/+/${RESET_COLOR} azazel rootkit has been removed\n"
}

jynx2()
{
    printf "${GREEN}/+/${RESET_COLOR} removing jynx2 rootkit\n\n"

    export LD_PRELOAD="$JYNX2_INSTALL/reality.so"

    if [[ $(strings $LD_PRELOAD) == *"opendir"* ]]; then
        printf "${GREEN}/+/${RESET_COLOR} shared object files were found in $JYNX2_INSTALL/, jynx2 has been located\n
        creating symbolic link to ld_preload file\n\n"
    else
        printf "${RED}/-/${RESET_COLOR} shared object files not found in $JYNX2_INSTALL/
        it was either installed elsewhere or jynx2 is not installed
        exiting\n"
        exit
    fi

    LD_PRELOAD=$JYNX2_INSTALL/reality.so ln -sf /etc/ld.so.preload /tmp/tmp_ld_preload

    printf "${GREEN}/+/${RESET_COLOR} symbolic link created, now removing the library\n\n"

    echo 0 > /tmp/tmp_ld_preload
    rm -rf /etc/ld.so.preload

    printf "${GREEN}/+/${RESET_COLOR} copying the shared object files to /tmp\n\n"

    cp $JYNX2_INSTALL/jynx2.so /tmp/jynx2.so
    cp $JYNX2_INSTALL/reality.so /tmp/reality.so

    rm -rf $JYNX2_INSTALL/jynx2.so $JYNX2_INSTALL/reality.so

    printf "${GREEN}/+/${RESET_COLOR} jynx2 rootkit has been removed\n"
}

if [ $(id -u) != 0 ]; then
    printf "${RED}/-/${RESET_COLOR} $0 not ran as root, exiting\n"
    exit
fi

if [ -z "$1" ]; then
    printf "${RED}/-/${RESET_COLOR} argument not given\n"
    usage
    exit
fi

if [ "$1" == "azazel" ]; then
    azazel
    exit
elif [ "$1" == "jynx2" ]; then
    jynx2
    exit
else
    printf "${RED}/-/${RESET_COLOR} $1 is not a valid option\n"
    usage
    exit
fi
