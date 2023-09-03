# This script creates symlinks from the home directory to any desired dotfiles in /home/fergalm/dotfiles
############################
#ignore
########## Variables
MACHINE_TYPE=$(uname -m)

dir=/home/fergalm/dotfiles                                                                                             # dotfiles directory
olddir=/home/fergalm/dotfiles_old                                                                                      # old dotfiles backup directory
files="gitconfig pylint.rc tmux.conf.local muttrc zshrc bash_aliases bash_functions bash_dirhooks sqliterc Xresources" # list of files/folders to symlink in homedir

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

echo Setting git stuff
git config --global user.email "fergal.moran@gmail.com"
git config --global user.name "Fergal Moran"

#install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm /home/fergalm/.tmux/plugins/tpm

sudo locale-gen "en_IE.UTF-8"
sudo pip install livereload speedtest-cli virtualenv virtualenvwrapper
