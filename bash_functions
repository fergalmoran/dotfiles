#!/usr/bin/env bash
function ff(){
    find | grep -i $1
}
function run_osx() {
    docker run \
        --device /dev/kvm \
        --device /dev/snd \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        fmosx
}
function dnefm(){
    #creates a new .net migration and applies it
    dotnet ef migrations add $1
    dotnet ef database update 
}
function add_ferglie_ip() {
    az account set --subscription DSS 
    az network dns record-set a add-record -g rg-ferglie -z fergl.ie -n $1 -a 109.255.216.213
}
function kcda(){
    kubectl delete -f ./$1 && kubectl apply -f ./$1 && watch kubectl get pods --namespace default
}
function gffs(){
    gr @$CURRENT_REPO git flow feature start $1
}
function gfff(){
    gr @$CURRENT_REPO git flow feature finish $1
}
function gfhs(){
    gr @$CURRENT_REPO git flow hotfix start $1
}
function gfhf(){
    gr @$CURRENT_REPO git flow hotfix finish $1
}
function gitzip() { 
	git archive -o $@.zip HEAD
}
function gitReleaseNoVersion() {
    git checkout trunk && git merge develop && git push origin trunk develop && git checkout develop
}
function gitRelease() {
    npm version patch && \
        git checkout trunk && git merge develop && git push origin trunk develop && git checkout develop
}
function md {
  command mkdir $1 && cd $1
}

function pips() {
    echo $'\n'$1 >> requirements.txt; pip install $1
}

kubetoken(){
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/^kubernetes-dashboard-token-/{print $1}') | awk '$1=="token:"{print $2}' | pbcopy
}
function reset_rider() {
    _reset_jb Rider
}
function reset_pycharm() {
    _reset_jb PyCharm
}
function reset_webstorm() {
    _reset_jb WebStorm
}
function _reset_jb(){
    rm -rf ~/.config/JetBrains/$1*/eval
    rm -rf ~/.config/JetBrains/$1*/options/other.xml
    sed -i -E 's/<property name=\"evl.*\".*\/>//' ~/.config/JetBrains/$1*/options/other.xml
    # rm -rf ~/.java/.userPrefs/jetbrains/rider$1/
}

cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

function gi() { curl -L -s https://www.gitignore.io/api/\$@ ;}

function update-x11-forwarding
{
    if [ -z "$STY" -a -z "$TMUX" ]; then
        echo $DISPLAY > ~/.display.txt
    else
        export DISPLAY=`cat ~/.display.txt`
    fi
}

# This is run before every command.
preexec() {
    # Don't cause a preexec for PROMPT_COMMAND.
    # Beware!  This fails if PROMPT_COMMAND is a string containing more than one command.
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return 

    update-x11-forwarding

    # Debugging.
    #echo DISPLAY = $DISPLAY, display.txt = `cat ~/.display.txt`, STY = $STY, TMUX = $TMUX  
}
trap 'preexec' DEBUG

function update_vscode(){
    wget https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable -O /tmp/code_latest_amd64.deb
    sudo dpkg -i /tmp/code_latest_amd64.deb
}

