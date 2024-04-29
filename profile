export QT_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME="qt5ct"

export LANG="en_IE.UTF-8"
export PATH=$PATH:$HOME/.bin:$HOME/npm-global/bin:$HOME/.bun/bin:$HOME/dotfiles/bin:$HOME/go/bin:/usr/lib/go-1.9/bin
export EDITOR='vim'
export VISUAL=$EDITOR
export ZSH=$HOME/oh-my-zsh
export HISTFILESIZE=5000000
export HISTSIZE=5000000
export LIBVIRT_DEFAULT_URI="qemu:///system"
export QT_SCALE_FACTOR=2
export QT_SCREEN_SCALE_FACTORS=1
export ENV=$HOME/.prv/env
if test -f $ENV; then
    source $ENV
fi

# Added by Toolbox App
export PATH="$PATH:/home/fergalm/.local/share/JetBrains/Toolbox/scripts"

source $HOME/.bash_aliases
source $HOME/.bash_functions
source $HOME/.bash_dirhooks

export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_ROOT_64=$DOTNET_ROOT
export DOTNET_HOST_PATH=$DOTNET_ROOT/dotnet
export DOTNET_WATCH_RESTART_ON_RUDE_EDIT=1
export PATH="$DOTNET_ROOT:$PATH:$DOTNET_ROOT/tools"

#android stuff
export ANDROID_SDK_ROOT=/opt/android/sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/platforms:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATH
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH


export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
