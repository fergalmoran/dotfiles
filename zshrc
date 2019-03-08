export PATH=$PATH:/home/fergalm/dotfiles/bin:/home/fergalm/go/bin:/opt/android/sdk/platform-tools/:/usr/lib/go-1.9/bin
export TERM="xterm-256color"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:$PATH:/home/fergalm/.local/bin/:/opt/etcher-cli
export PATH=$PATH:/opt/android/flutter/bin:/opt/android/sdk/tools:/opt/android/sdk/platform-tools:/opt/android/sdk/tools/bin/:/home/fergalm/working/chromium/depot_tools
export JAVA_HOME=/opt/android/android-studio/jre/

export WINEPREFIX="/home/fergalm/.wine32" 
# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

export VISUAL=vim
export EDITOR="$VISUAL"

export OPENFAAS_URL=swarm-master:8080

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="muse"
#ZSH_THEME="random"
ZSH_THEME="powerlevel9k/powerlevel9k"


# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(virtualenv)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_folders
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
    git
    github
    docker
    docker-compose
    git-ignore
    git-flow
    git-flow-completion
    virtualenvwrapper
)
export ZSH=/home/fergalm/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
source /usr/share/autojump/autojump.sh
source /usr/local/bin/virtualenvwrapper.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='gvim'
fi

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="vi ~/.zshrc"
# alias ohmyzsh="vi ~/.oh-my-zsh"

if [ -f /home/fergalm/dotfiles/.private.env ]; then
    source '/home/fergalm/dotfiles/.private.env'
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
unalias gr
unalias g
source ~/.bash_aliases
source ~/.bash_functions
source ~/.bash_dirhooks

. "/home/fergalm/.acme.sh/acme.sh.env"
