#!/usr/bin/env bash
INSTALL_DIR=/opt/code-insiders/
TMP_FILE=/tmp/vsc.tar.gz
BUILD=insider

if [ -f "$TMP_FILE" ]; then
    rm $TMP_FILE
fi
echo "Downloading tgz..."
curl -L -X GET -L -G https://code.visualstudio.com/sha/download \
    -d build=$BUILD \
    -d os=linux-x64 \
    --output $TMP_FILE

sudo mkdir -p $INSTALL_DIR
sudo chown $USER $INSTALL_DIR
tar zxfv $TMP_FILE -C $INSTALL_DIR --strip-components=1
sudo ln -sfn "${INSTALL_DIR}bin/code-insiders" /usr/bin/code-insiders
sudo xdg-mime default vscode-insiders-url-handler.desktop x-scheme-handler/vscode-insiders
