IP=$(hostname -I | cut -d' ' -f1)
HOSTNAME=`hostname -s`
# ignore
alias ls="ls -alh"

alias whatismyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias itunes="wine /home/fergalm/.wine32/drive_c/Program\ Files/iTunes/iTunes.exe"

alias tmuxj="export DISPLAY=:0 && tmux -d attach"
alias robo3t="/home/fergalm/bin/robo3t-1.2.1-linux-x86_64-3e50a65/bin/robo3t > /dev/null 2>&1 &"
#kubernetes stuff
alias k="kubectl"
#.NET stuff
alias dndev="export ASPNETCORE_ENVIRONMENT=Development"
alias dnprod="export ASPNETCORE_ENVIRONMENT=Production"
alias dnrun="export ASPNETCORE_ENVIRONMENT=Development && dotnet watch --project ./podnoms-api/podnoms-api.csproj run --urls http://0.0.0.0:5000"
alias dnprodrun="export ASPNETCORE_ENVIRONMENT=Production && dotnet watch --project ./podnoms-api/podnoms-api.csproj run"

#docker stuff
alias dcup="docker-compose up -d && docker-compose logs -f"
alias dcdup="docker-compose stop && docker-compose pull && docker-compose up -d && docker-compose logs -f"

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

alias g="/usr/local/bin/gr @$CURRENT_REPO git "

alias sqlw="/opt/SqlWorkbench/sqlworkbench.sh &"
alias se="/opt/StorageExplorer/StorageExplorer > /dev/null 2>&1 &"
alias dbv="dbeaver > /dev/null 2>&1 &"
alias sqlops="/opt/sqlops-linux-x64/sqlops > /dev/null 2>&1 &"
alias rsl="rslsync --config /home/fergalm/.config/resilio-sync/config.json"

# alias reloadbashrc="source ~/.bashrc"
alias rlz="source ~/.zshrc"
alias server="livereload -p 9999 --host $IP"
alias upd="sudo apt update && sudo apt -y dist-upgrade && sudo apt -y autoremove"
alias psql="sudo -u postgres psql deepsouthsounds"
alias code="/usr/bin/code-insiders"
alias c="/usr/bin/code-insiders ."

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

doAgFind(){
    ag --ignore-dir node_modules --ignore-dir bower_components $1
}
alias ag=doAgFind

doGrepSearch(){
    find | grep $1
}
alias f=doGrepSearch

doPsKill(){
    sudo ps aux | grep -ie $1 | awk '{print $2}' | xargs kill -9
}
alias pskill=doPsKill

alias tmux="TERM=screen-256color-bce tmux attach || TERM=screen-256color-bce tmux"
