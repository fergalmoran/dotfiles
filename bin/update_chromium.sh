#!/bin/bash
#
# Update to latest chromium nightly on linux
# Script requires root to properly set up the sandbox
# https://code.google.com/p/chromium/wiki/LinuxSUIDSandboxDevelopment
# 
# I use it with a line like the following in my .bashrc:
# alias canary='CHROME_DEVEL_SANDBOX="/home/fergalm/bin/chrome-linux/chrome_sandbox" /home/fergalm/bin/chrome-linux/chrome-wrapper'
#
# ----------------------------------------------------------------------
# forked from https://gist.github.com/craSH/236563
# Original comments / copyright follows:
#
#    Simple script to update OSX Chromium to the latest nightly build.
#    Will not download if you already have the latest (call with --force
#    to override this check)
#
#    Copyleft 2010 Ian Gallagher <crash@neg9.org>
# ----------------------------------------------------------------------


LATEST=$(curl -s "http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux_x64/LAST_CHANGE")
REMOTE="http://commondatastorage.googleapis.com/chromium-browser-continuous/Linux_x64/247920/chrome-linux.zip"
TMP=$(mktemp -d)
ZIP="$TMP/chrome-linux.zip"
OUT="$TMP/chrome-linux"
BIN="/home/fergalm/bin"
INSTALL="$BIN/chrome-linux"
BACKUP=$(mktemp -d --tmpdir=$BIN/old/chrome-linux)

# Grab the current SVN revision of Chromium installed on the system
# from the file we created last installation called BUILD
if [ ! -f $INSTALL/BUILD ];
then
    INSTALLED_VERSION=0
else
    INSTALLED_VERSION=$(cat $INSTALL/BUILD)
fi

if [ $INSTALLED_VERSION -ge $LATEST -a "--force" != "$1" ]; then
    echo "Current or later version already installed"
    exit 0
fi

cd $TMP
echo "Working directory: "$PWD;

echo "Downloading build $LATEST..."
curl -# -o $ZIP $REMOTE || exit;

echo "Extracting ..."
unzip $ZIP >/dev/null || exit;

echo "Installing ..."
echo $LATEST > $OUT/BUILD
mv $INSTALL $BACKUP
mv $OUT $BIN
echo "Previous version moved to $BACKUP"

echo "Cleaning up ..."
rm -rf $TMP

echo ""
echo "We need sudo to set up sandbox. This will run:"
echo "$(grep sudo $BASH_SOURCE | grep -v echo)"
echo ""
echo 'Where $INSTALL='$INSTALL
echo ""
echo "Any key to continue."
echo -n "Pressing Ctrl-C and doing this by hand would be much safer ..."
read -r FOO
sudo chown root:root $INSTALL/chrome_sandbox
sudo chmod 4755 $INSTALL/chrome_sandbox
echo ""
echo "Done."
