# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################
#ignore
########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="tmux.conf zshrc bash_aliases bash_functions sqliterc Xresources"    # list of files/folders to symlink in homedir

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
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# merge Xresources
xrdb -merge ~/.Xresources

sudo cp -r fonts/* /usr/share/fonts/opentype
fc-cache -f -v
sudo fc-cache -f -v


git clone https://github.com/powerline/fonts.git pwfonts
cd pwfonts && ./install.sh

OMF=~/.oh-my-zsh/oh-my-zsh.sh
if [ ! -f $OMF ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

#install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#install git flow completion
git clone https://github.com/bobthecow/git-flow-completion ~/.oh-my-zsh/custom/plugins/git-flow-completion

# Setup default locales
sudo locale-gen "en_IE.UTF-8"

#install default packages
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt update
sudo apt-get install -y exuberant-ctags build-essential cmake python-dev python3-dev libssl-dev vim-youcompleteme autojump nodejs htop ncdu python-pip python3-pip byobu zsh vim-gtk python-setuptools neovim tree git-extras cowsay fortune winbind libpq-dev xclip whois
sudo pip install --upgrade pip
sudo pip install --upgrade neovim
sudo pip3 install --upgrade neovim
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

sudo pip install livereload speedtest-cli virtualenv virtualenvwrapper
sudo npm install -g goops

chsh -s /bin/zsh

git clone git@github.com:fergalmoran/vimfiles.git ~/.vim
ln -s ~/.vim/.vimrc ~/.vimrc

cd ~/.vim
git submodule init
git submodule update
vim +BundleInstall +qall

git config --global user.email "fergal.moran@gmail.com"
git config --global user.name "Fergal Moran"


mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf

