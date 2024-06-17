zmodload zsh/zprof
timer=$(($(date +%s%0N)/1000000))
source ~/.profile

export VISUAL=vim
export EDITOR="$VISUAL"
export HISTFILESIZE=5000000
export HISTSIZE=5000000

echo Loading zshrc
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
if [[ -z "${ZSH_THEME}" ]]; then
    #ZSH_THEME="random"
    ZSH_THEME="fino"
fi
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
source $HOME/dotfiles/pl9k.config

#Rust stuff
if test -f "$HOME/.cargo/env"; then
  source $HOME/.cargo/env
fi
# Python stuff
export VIRTUALENVWRAPPER=/usr/local/bin/virtualenvwrapper.sh
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:$PATH:/home/fergalm/.local/bin/:/opt/etcher-cli:/home/fergalm/.cargo/bin

# Postgres:
# these details are for localhost docker db only so safe enough to keep in github
PGPASSFILE=$HOME/.pgpass

# The Fuck!!
if hash thefuck 2>/dev/null; then
    eval $(thefuck --alias)
fi

export WINEPREFIX="/home/fergalm/.wine32"

export OPENFAAS_URL=cluster-master:31112

unsetopt MULTIBYTE

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

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

now=$(($(date +%s%0N)/1000000))
elapsed=$(($now-$timer))
echo ".zshrc loaded in ${elapsed}ms"
return
now=$(($(date +%s%0N)/1000000))
elapsed=$(($now-$timer))
echo ".zshrc loaded in ${elapsed}ms"
return
export CURRENT_REPO=podnoms
unalias gr 2>/dev/null
unalias g 2>/dev/null

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


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if hash go 2>/dev/null; then
    export PATH=$PATH:$(go env GOPATH)/bin
    export GOPATH=$(go env GOPATH)
fi

source /usr/share/nvm/init-nvm.sh

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

# pnpm
export PNPM_HOME="/home/fergalm/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/fergalm/.bun/_bun" ] && source "/home/fergalm/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)

# dnscontrol completion
eval "$(dnscontrol shell-completion zsh)"

# disable audio on all virtual machines
# this will bite me in the ass in the future
# but for now, bite me
export QEMU_AUDIO_DRV=none


now=$(($(date +%s%0N)/1000000))
elapsed=$(($now-$timer))
echo ".zshrc loaded in ${elapsed}ms"
