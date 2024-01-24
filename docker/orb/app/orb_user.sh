#!/bin/bash
# Accepts optional positional parameters
#  - user's name and password to be created
#  - path to the Orb installation
ORB_USER=${1:-demo}
ORB_PASS=${2:-prompt}
ORB_DIR=${3:-/var/www/orb}
ORB_HOME="$ORB_DIR"/home
USER_DIR="$ORB_HOME"/"$ORB_USER"

umask 022
mkdir -p "$ORB_HOME/Shared/"
USER_DIR="$ORB_HOME"/"$ORB_USER"
mkdir -p "$USER_DIR"/{Bookmarks,Desktop,Douments,Pictures,Temporary}
mkdir -p "$USER_DIR"/{Emulators,Emulators/C64,Emulators/DosBox}
cp -vp "$ORB_DIR"/public/images/wallpaper.jpg "$USER_DIR"/Pictures/
cp -vp "$ORB_DIR"/extra/user.settings "$USER_DIR"/.settings

if [[ "$ORB_PASS" == "prompt" ]]; then
  read -r -p "Enter password: " -s ORB_PASS; echo ""
fi

# parameters for Argon2i hash. (argon2 -i is argon2i)
ARGON2_VERSION=13
ARGON2_MEMORY=65536
ARGON2_ITERATIONS=4
ARGON2_OUTPUT=32
SALT_LENGTH=8
ARGON2_SALT=$(openssl rand -hex $SALT_LENGTH)
HASH_PASS=$(echo -n "$ORB_PASS" | argon2 "$ARGON2_SALT" -i -v $ARGON2_VERSION -k $ARGON2_MEMORY -t $ARGON2_ITERATIONS -l $ARGON2_OUTPUT -e)
echo "$ORB_USER:$HASH_PASS" >> "$ORB_HOME"/users.txt
exit 0