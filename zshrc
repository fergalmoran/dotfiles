timer=$(($(date +%s%0N)/1000000))

echo Loading zshrc
export LANG="en_IE.UTF-8"
export PATH=$PATH:$HOME/npm-global/bin:$HOME/dotfiles/bin:$HOME/go/bin:/usr/lib/go-1.9/bin
export EDITOR='vim'
export VISUAL=$EDITOR
export ZSH=$HOME/oh-my-zsh
export HISTFILESIZE=5000000
export HISTSIZE=5000000

export ENV=$HOME/.prv/env
if test -f $ENV; then
    source $ENV
fi

if test -f ~/.zshrc_local; then
    echo $ZSH_THEME
fi

if test -f "~/.prv/env"; then
    source ~/.prv/env
fi

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="random"
ZSH_APPROVED_THEMES=(
    "fino",
    "refined",
    "juanghurtado",
    "smt",
    "peepcode",
    "trapd00r",
    "mrtazz",
    "bureau",
    "kiwish",
    "fox"
)
if [[ -z "${ZSH_THEME}" ]]; then
    #ZSH_THEME="random"
    ZSH_THEME="fino"
fi

#Rust stuff
source $HOME/.cargo/env

# Python stuff
export VIRTUALENVWRAPPER=/usr/local/bin/virtualenvwrapper.sh
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:$PATH:/home/fergalm/.local/bin/:/opt/etcher-cli

# Postgres:
# these details are for localhost docker db only so safe enough to keep in github
PGPASSFILE=$HOME/.pgpass

# The Fuck!!
if hash thefuck 2>/dev/null; then
    eval $(thefuck --alias)
fi

export WINEPREFIX="/home/fergalm/.wine32"
# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

export VISUAL=vim
export EDITOR="$VISUAL"
export HISTFILESIZE=5000000
export HISTSIZE=5000000


export OPENFAAS_URL=cluster-master:31112

export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_ROOT_64=$DOTNET_ROOT
export DOTNET_HOST_PATH=$DOTNET_ROOT/dotnet
export DOTNET_WATCH_RESTART_ON_RUDE_EDIT=1
export PATH="$DOTNET_ROOT:$PATH:$DOTNET_ROOT/tools"

unsetopt MULTIBYTE

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
source /home/fergalm/dotfiles/pl9k.config

export ZSH=/home/fergalm/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    autoupdate
    git
    github
    docker
    docker-compose
    gitignore
    git-flow
    git-flow-completion
    virtualenvwrapper
    zsh-syntax-highlighting
    zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='vim'
fi

# ssh
export SSH_KEY_PATH=$HOME/.ssh/rsa_id

if [ -f $HOME/dotfiles/.private.env ]; then
    source $HOME/dotfiles/.private.env
fi
_dotnet_zsh_complete()
{
    local dotnetPath=$words[1]
    local completions=("$(dotnet complete "$words")")
    reply=( "${(ps:\n:)completions}" )
}
compctl -K _dotnet_zsh_complete dotnet
# If not running interactively, do not do anything
[[ $- != *i* ]] && return

export CURRENT_REPO=podnoms
unalias gr 2>/dev/null
unalias g 2>/dev/null

source $HOME/.bash_aliases
source $HOME/.bash_functions
source $HOME/.bash_dirhooks

if hash kubectl 2>/dev/null; then
    source <(kubectl completion zsh)
    export KUBECONFIG=$HOME/.kube/config
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

#android stuff
export ANDROID_HOME=/opt/android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:/opt/flutter/bin
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH=$PATH:/opt/android/sdk/platform-tools/:/opt/android/sdk/cmdline-tools/latest/bin/:/opt/android/sdk/tools/

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if hash go 2>/dev/null; then
    export PATH=$PATH:$(go env GOPATH)/bin
    export GOPATH=$(go env GOPATH)
fi

if hash nvim 2>/dev/null; then
    source /usr/share/nvm/init-nvm.sh
fi

#this adds 200ms to zsh startup
if false; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
if hash mcfly 2>/dev/null; then
    eval "$(mcfly init zsh)"
fi

export FLYCTL_INSTALL=$HOME/.fly
export PATH="$FLYCTL_INSTALL/bin:$PATH"

if test -f /home/fergalm/.config/broot/launcher/bash/br; then
    source /home/fergalm/.config/broot/launcher/bash/br
fi

now=$(($(date +%s%0N)/1000000))
elapsed=$(($now-$timer))
echo ".zshrc loaded in ${elapsed}ms"

# pnpm
export PNPM_HOME="/home/fergalm/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# Scaleway CLI autocomplete initialization.
eval "$(scw autocomplete script shell=zsh)"

# Load Angular CLI autocompletion.
source <(ng completion script)

#

# bun completions
[ -s "/home/fergalm/.bun/_bun" ] && source "/home/fergalm/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
