#!/bin/bash

echo "load init-v18.5.21"

# disable bash flow control(C-s/C-q)
stty -ixon

# bind C-w to delete word
stty werase undef
bind '\C-w: backward-kill-word'


INIT_CONFIG_FILE="$HOME/.init.conf"
SCRIPT=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$SCRIPT")
USER_NAME=
VIM_CONFIG=
INITING=$([ -f "$INIT_CONFIG_FILE" ];echo $?)

load_script()
{
    if [ -f "$1" ]; then
        . "$1"
    fi
}

init_config()
{
    if [ -f "$1" ]; then
        mv -f "$1" "$1".old
    fi

    echo "source $SCRIPT" >> $HOME/.bashrc

    read -r -p "Enter your git email:" USER_EMAIL
    USER_NAME=${USER_EMAIL%@*}
    echo "export USER_NAME='$USER_NAME'" >> "$1"
    echo "export USER_EMAIL='$USER_EMAIL'" >> "$1"
    init_git_config "$USER_NAME" "$USER_EMAIL"

    read -r -p "Should I config vim?[y]:" VIM_CONFIG
    if [[ "$VIM_CONFIG" =~ ^[nN]+$ ]] ; then
        VIM_CONFIG=n
    else
        VIM_CONFIG=y
        init_vim_config
    fi
    echo "export VIM_CONFIG=$VIM_CONFIG" >> "$1"

    read -r -p "Should I config tmux?[y]:" TMUX_CONFIG
    if [[ "$TMUX_CONFIG" =~ ^[nN]+$ ]] ; then
        TMUX_CONFIG=n
    else
        TMUX_CONFIG=y
        init_tmux_config
    fi
    echo "export TMUX_CONFIG=$TMUX_CONFIG" >> "$1"
}

init_git_config()
{
    source $SCRIPTPATH/git/git-prompt.sh
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\[\033[36m\]$(__git_ps1)\[\033[0m\]\n\$ '

    git config --global user.name "$1"
    git config --global user.email "$2"
    git config --global push.default simple
    git config --global core.autocrlf false
    git config --global core.filemode false
    git config --global color.ui true
    git config --global core.editor "vim"
    git config --global alias.co commit
    git config --global alias.br branch
    git config --global alias.st status
    git config --global alias.fe fetch
    git config --global alias.ch checkout
    git config --global alias.lg "log --oneline --decorate --graph -20"
    git config --global alias.lg "log --graph --pretty=format:'%C(yellow)%h%Creset %C(green)%d%Creset %s %C(dim white)<%an>%Creset %C(dim white)(%cr)%C(reset)' --abbrev-commit -20"
    git config --global alias.lga "log --graph --pretty=format:'%C(yellow)%h%Creset %C(green)%d%Creset %s %C(dim white)<%an>%Creset %C(dim white)(%cr)%C(reset)' --abbrev-commit -20 --all"
    # ignore the tracked file
    git config --global alias.ignore "update-index --assume-unchanged"
    # unignore the tracked file
    git config --global alias.unignore "update-index --no-assume-unchanged"
    # display all ignored tracked files
    git config --global alias.ignored "!git ls-files -v | grep '^[[:lower:]]'"
}

init_vim_config()
{
    if [ -f "$HOME/.vimrc" ]; then
        mv "$HOME/.vimrc" "$HOME/.vimrc.old"
    fi
    if [ -d "$HOME/.vim" ]; then
        mv "$HOME/.vim" "$HOME/.vim.old"
    fi
    
    ln -s "$SCRIPTPATH/vim/.vimrc" "$HOME/.vimrc"
    ln -s "$SCRIPTPATH/vim/.vim" "$HOME/.vim"
}

init_tmux_config()
{
    if [ -f "$HOME/.tmux.conf" ]; then
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.old"
    fi
    
    ln -s "$SCRIPTPATH/tmux/.tmux.conf" "$HOME/.tmux.conf"
}

init_other_config()
{   
    if [ ! -d "$HOME/bin" ]; then
        mkdir "$HOME/bin"
    fi
    if [ ! -f "$HOME/bin/move-to-next-monitor" ]; then
        ln -s "$SCRIPTPATH/bin/move-to-next-monitor" "$HOME/bin/move-to-next-monitor"
    fi
}

load_script "$INIT_CONFIG_FILE"
if [ $INITING = 1 ]; then 
    init_config "$INIT_CONFIG_FILE"
fi

PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\[\033[36m\]$(__git_ps1)\[\033[0m\]\n\$ '

export PATH=$SCRIPTPATH/bin:$PATH
export PATH=$SCRIPTPATH/depot_tools:$PATH
export MANPATH=$SCRIPTPATH/man:$MANPATH

export DEPOT_TOOLS_UPDATE=0

alias viminit='vim $SCRIPT'
alias sourceinit='source $SCRIPT'
alias e=vim
alias v=vim
alias rg='rg -C 1 -F'
alias tmux='tmux -2'

export PATH=$SCRIPTPATH/ripgrep:$PATH
source $SCRIPTPATH/ripgrep/complete/rg.bash-completion

source $SCRIPTPATH/tmux/tmux.bash-completion

export PATH=$SCRIPTPATH/fd/usr/bin:$PATH
source $SCRIPTPATH/fd/usr/share/bash-completion/completions/fd

export TERM="xterm-256color"

export PATH=$SCRIPTPATH/p4merge/bin:$PATH

if [ -f $SCRIPTPATH/.initrc ]; then
    . $SCRIPTPATH/.initrc
fi

