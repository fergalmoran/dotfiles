IP=$(hostname -I | cut -d' ' -f1)
HOSTNAME=`hostname -s`
# ignore
alias ls="ls -alh"

alias whatismyip="dig +short myip.opendns.com @resolver1.opendns.com"

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

alias sqlw="/opt/SqlWorkbench/sqlworkbench.sh &"
alias se="/opt/StorageExplorer/StorageExplorer > /dev/null 2>&1 &"
alias dbv="dbeaver > /dev/null 2>&1 &"
alias rsl="rslsync --config /home/fergalm/.config/resilio-sync/config.json"

alias reloadbashrc="source ~/.bashrc"
alias server="livereload -p 9999 --host $IP"
alias upd="sudo apt update && sudo apt dist-upgrade && sudo apt autoremove"
alias psql="sudo -u postgres psql deepsouthsounds"
alias code="/usr/bin/code-insiders"
alias c="/usr/bin/code-insiders ."

alias dbstatus="dropbox.py status"
alias dbignore='find `pwd` -type d -regex ".*\(node_modules\|temp\|tmp\|bower_components\|cache\)$" -prune -exec dropbox exclude add {} \;'
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

alias dcx="docker-compose -H podnoms.com:2376 --tlsverify --tlscacert /mnt/niles/sharing/docker-tls/podnoms/ca.pem --tlscert /mnt/niles/sharing/docker-tls/podnoms/cert.pem --tlskey /mnt/niles/sharing/docker-tls/podnoms/key.pem"

case $HOSTNAME in
    (NILES) alias dockerx="docker --tlsverify -H=podnoms.com:2376 --tlscacert=/srv/sharing/docker-tls/podnoms/ca.pem --tlscert=/srv/sharing/docker-tls/podnoms/cert.pem --tlskey=/srv/sharing/docker-tls/podnoms/key.pem";;
    (EDDIE) alias dockerx="docker --tlsverify -H=podnoms.com:2376 --tlscacert=/mnt/niles/sharing/docker-tls/podnoms/ca.pem --tlscert=/mnt/niles/sharing/docker-tls/podnoms/cert.pem --tlskey=/mnt/niles/sharing/docker-tls/podnoms/key.pem";;
esac

if type "$docker" >  /dev/null; then
    alias docker-nuke="docker rm $(docker ps -a -q) && docker rmi $(docker images -q)"
    alias dc='docker-compose'
    alias docker-rm-untagged='docker rmi -f $(docker images | grep "^<none>" | awk "{print $3}")'
fi
alias tmux="TERM=screen-256color-bce tmux attach || TERM=screen-256color-bce tmux"
