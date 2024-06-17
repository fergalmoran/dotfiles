alias ssh="TERM=xterm ssh" #fix kitty setting term in SSH sessions and borking keystrokes
alias dmesg="sudo dmesg"
alias dnr="export ASPNETCORE_ENVIRONMENT=Development && dotnet watch --project ./$DOTNET_PROJ/$DOTNET_PROJ.csproj run"
alias dndel="find . -iname \"bin\" -o -iname \"obj\" | xargs rm -rfv"
alias gitversion="dotnet-gitversion"
alias ls="lsd -al "
alias vi="vim"
alias vim="nvim"
alias whatismyip="dig +short txt ch whoami.cloudflare @1.0.0.1 | sed 's/\"//g'"
alias wanip="whatismyip"
alias nordcon="nordvpn whitelist add subnet 10.1.1.1/24 && nordvpn set technology openvpn && nordvpn connect uk1604"
alias pnpx='pnpm dlx'
alias x='xdg-open'
alias foxy='firefox -CreateProfile "foxy /tmp/foxy" && firefox -P foxy'
alias chromey='google-chrome-stable --user-data-dir=/tmp/chromy'

alias code="code-insiders"
#docker stuff
alias dpsa='docker ps -a --format "table {{.ID}} {{.Names}}\t{{printf \"%.25s\" .Image}}\t{{.Status}}\t{{.Ports}}"'
alias dockernuke='docker kill $(docker ps -q) && docker system prune -a'
alias dockervolnuke='docker volume ls -qf dangling=true | xargs -r docker volume rm'
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
alias gpomd="git push origin master develop"
alias gpotd="git push origin trunk develop"
alias git-browse="xdg-open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"

alias sqlw="/opt/SqlWorkbench/sqlworkbench.sh &"
alias se="/opt/StorageExplorer/StorageExplorer > /dev/null 2>&1 &"
alias dbv="dbeaver > /dev/null 2>&1 &"
alias sqlops="/opt/sqlops-linux-x64/sqlops > /dev/null 2>&1 &"
alias rsl="rslsync --config /home/fergalm/.config/resilio-sync/config.json"

# alias reloadbashrc="source ~/.bashrc"
alias rlz="source ~/.zshrc"
alias server="livereload -p 9999"
alias upd="paru -Syu --noconfirm"
alias updfrasier="ssh frasier 'sudo apt-get update && sudo apt-get -y dist-upgrade'"
alias updarch="paru -Syu"
# alias psql="sudo -u postgres psql deepsouthsounds"

alias dbstatus="docker exec -t -i dropbox dropbox status"
alias dbcreate="docker run -d --restart=always --cpus=".2" --name=dropbox -v /home/fergalm/dev:/dbox/Dropbox/dev -v /home/fergalm/Dropbox:/dbox/Dropbox janeczku/dropbox"
alias dbignore='find `pwd` -type d -regex ".*\(node_modules\|temp\|tmp\|bower_components\|cache\)$" -prune -exec docker exec -t -i dropbox dropbox exclude add {} \;'
alias dbrm="find . -name \*\'s\ conflicted\ copy\ \* -exec rm  {} \;"
alias ping="ping -O"
alias ping1="ping -O 1.1.1.1"

alias xclip='xargs echo -n | xclip -selection clipboard'
alias pbcopy='xargs echo -n | xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias iotop='sudo iotop'
alias rmq=' sudo rabbitmqctl'
alias congo='node /srv/dev/working/congo/server.js'

alias zap='/home/fergalm/working/ZAP/zap.sh > /dev/null 2>&1 &'

alias andconnect='adb connect 10.1.1.102:5555'

doAgFind() {
    ag --ignore-dir node_modules --ignore-dir bower_components $1
}
alias fag=doAgFind

doGrepSearch() {
    find | grep $1
}
alias f=doGrepSearch

doPsKill() {
    sudo ps aux | grep -ie $1 | awk '{print $2}' | xargs kill -9
}
alias pskill=doPsKill

alias tmux="TERM=screen-256color-bce tmux attach || TERM=screen-256color-bce tmux"
alias ngs="ng serve"
