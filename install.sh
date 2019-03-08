# This script creates symlinks from the home directory to any desired dotfiles in /home/fergalm/dotfiles
############################
#ignore
########## Variables
MACHINE_TYPE=`uname -m`

dir=/home/fergalm/dotfiles                    # dotfiles directory
olddir=/home/fergalm/dotfiles_old             # old dotfiles backup directory
files="pylint.rc tmux.conf zshrc bash_aliases bash_functions bash_dirhooks sqliterc Xresources"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv /home/fergalm/.$file /home/fergalm/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file /home/fergalm/.$file
done

# merge Xresources
xrdb -merge /home/fergalm/.Xresources

git clone https://github.com/powerline/fonts.git pwfonts
cd pwfonts && ./install.sh

#install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm /home/fergalm/.tmux/plugins/tpm

sudo apt-get install -y exuberant-ctags build-essential cmake python-dev python3-dev libssl-dev vim-youcompleteme autojump htop ncdu python-pip python3-pip byobu zsh vim-gtk python-setuptools tree git-extras cowsay fortune winbind libpq-dev xclip whois


# Setup default locales
sudo locale-gen "en_IE.UTF-8"

sudo pip install livereload speedtest-cli virtualenv virtualenvwrapper

#install git flow completion
OMF=/home/fergalm/.oh-my-zsh/oh-my-zsh.sh
if [ ! -f $OMF ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/bobthecow/git-flow-completion /home/fergalm/.oh-my-zsh/custom/plugins/git-flow-completion
fi
