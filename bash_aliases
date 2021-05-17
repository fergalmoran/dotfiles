# ignore
alias vi="vim"
alias ls="lsd -alh"
alias locate="plocate"
alias dmesg="sudo dmesg"

alias ytdl="youtube-dl"
alias findpis="arp -na | grep -i 'b8:27:eb'"

alias whatismyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias itunes="wine /home/fergalm/.wine32/drive_c/Program\ Files/iTunes/iTunes.exe"

alias code="/usr/bin/code-insiders"
alias c="code-insiders"
alias edclust="code /home/fergalm/dev/clusters/workspace.code-workspace"

alias yay="paru"
alias pwgen="openssl rand -base64 32"
alias tmuxj="export DISPLAY=:0 && tmux -d attach"
alias robo3t="/home/fergalm/bin/robo3t-1.2.1-linux-x86_64-3e50a65/bin/robo3t > /dev/null 2>&1 &"
#javascript stuff
alias nodenuke="rm -rf package-lock.json node_modules && npm i"
#editorconfigs
alias js_editorconfig="cp /home/fergalm/dotfiles/editorconfigs/editorconfig.javascript .editorconfig"
alias csharp_editorconfig="cp /home/fergalm/dotfiles/editorconfigs/editorconfig.csharp .editorconfig"
#kubernetes stuff
alias k="kubectl"
#.NET stuff
alias dndev="export ASPNETCORE_ENVIRONMENT=Development"
alias dndel="find . -iname \"bin\" -o -iname \"obj\" | xargs rm -rfv"
alias dnprod="export ASPNETCORE_ENVIRONMENT=Production"
alias pnr="export ASPNETCORE_ENVIRONMENT=Development && dotnet watch --project ./podnoms-api/podnoms-api.csproj run"
alias dnprodrun="export ASPNETCORE_ENVIRONMENT=Production && dotnet watch --project ./podnoms-api/podnoms-api.csproj run"

#docker stuff
alias dcup="docker-compose up --remove-orphans"
alias dcupd="docker-compose up --remove-orphans -d && docker-compose logs -f"
alias dcstop="docker-compose stop"
alias dclog="docker-compose logs -f"
alias dcdup="docker-compose stop && docker-compose pull && docker-compose up --remove-orphans -d && docker-compose logs -f"
alias dpsa='docker ps -a --format "table {{.ID}} {{.Names}}\t{{printf \"%.25s\" .Image}}\t{{.Status}}\t{{.Ports}}"'

#Django stuff
alias djrun="source /home/fergalm/dev/personal/deepsouthsounds.com/dss.docker/api_env && python manage.py runserver 0.0.0.0:8001"
alias djshell="python manage.py shell_plus --use-pythonrc --ipython"
alias djdb="python manage.py dbshell"
alias djmigrate="python manage.py schemamigration spa --auto"
alias wole="source ./env/bin/activate"

alias dss="cd ~/dev/personal/deepsouthsounds.com/dss.api && workon dss.api"
alias dss_radio="cd ~/dev/personal/deepsouthsounds.com/dss.radio && workon dss.radio && docker start dssdocker_icecast_1"

alias pgdo="sudo -u postgres"
alias pgadmin="docker run -it --rm -v /home/fergalm/working/pgadmin-data:/pgadmin-data --net=host fergalmoran/pgadmin4:latest; xdg-open http://localhost:5050"
alias runmssql="docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=cTXu1nJLCpC/c' -p 1433:1433 -v /home/fergalm/working/mssql-data:/var/opt/mssql -d microsoft/mssql-server-linux"
alias tor="docker run -i -t --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro paulczar/torbrowser"

alias g="gr @$CURRENT_REPO git "

alias sqlw="/opt/SqlWorkbench/sqlworkbench.sh &"
alias se="/opt/StorageExplorer/StorageExplorer > /dev/null 2>&1 &"
alias dbv="dbeaver > /dev/null 2>&1 &"
alias sqlops="/opt/sqlops-linux-x64/sqlops > /dev/null 2>&1 &"
alias rsl="rslsync --config /home/fergalm/.config/resilio-sync/config.json"

# alias reloadbashrc="source ~/.bashrc"
alias rlz="source ~/.zshrc"
alias server="livereload -p 9999"
alias upd="sudo apt update && sudo apt -y dist-upgrade && sudo apt -y autoremove && sudo snap refresh"
alias updarch="yay -Syu"
alias updniles="ssh niles sudo 'apt-get update && sudo apt-get -y dist-upgrade'"
alias psql="sudo -u postgres psql deepsouthsounds"

alias dbstatus="docker exec -t -i dropbox dropbox status"
alias dbcreate="docker run -d --restart=always --cpus=".2" --name=dropbox -v /home/fergalm/dev:/dbox/Dropbox/dev -v /home/fergalm/Dropbox:/dbox/Dropbox janeczku/dropbox"
alias dbignore='find `pwd` -type d -regex ".*\(node_modules\|temp\|tmp\|bower_components\|cache\)$" -prune -exec docker exec -t -i dropbox dropbox exclude add {} \;'
alias dbrm="find . -name \*\'s\ conflicted\ copy\ \* -exec rm  {} \;"
alias ping="ping -O"

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias iotop='sudo iotop'
alias rmq=' sudo rabbitmqctl'
alias congo='node /srv/dev/working/congo/server.js'

alias zap='/home/fergalm/working/ZAP/zap.sh > /dev/null 2>&1 &'
alias git-browse="xdg-open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"

alias andconnect='adb connect 10.1.1.102:5555'

doAgFind() {
    ag --ignore-dir node_modules --ignore-dir bower_components $1
}
alias ag=doAgFind

doGrepSearch() {
    find | grep $1
}
alias f=doGrepSearch

doPsKill() {
    sudo ps aux | grep -ie $1 | awk '{print $2}' | xargs kill -9
}
alias pskill=doPsKill

alias tmux="TERM=screen-256color-bce tmux attach || TERM=screen-256color-bce tmux"
alias dnr="ASPNETCORE_ENVIRONMENT=development dotnet watch run"
alias ngs="ng serve"
