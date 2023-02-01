#!/bin/bash

if [ -z "$PS1" ]; then
    return
fi

echo "load keyou shell init v22.9.19"

if [ -n "$BASH_VERSION" ]; then
    IS_BASH=1
elif [ -n "$ZSH_VERSION" ]; then
    IS_ZSH=1
fi

# disable bash flow control(C-s/C-q)
stty -ixon

# disable terminal exit with C-d
set -o ignoreeof

stty werase undef

if [ "$IS_BASH" = 1 ]; then
    # bind C-w to delete word
    bind '\C-w: backward-kill-word'
fi

INIT_CONFIG_FILE="$HOME/.init.conf"

if [ "$IS_BASH" = 1 ]; then
    SCRIPT=$(readlink -f "$BASH_SOURCE")
    SCRIPTPATH=$(dirname "$SCRIPT")
elif [ "$IS_ZSH" = 1 ]; then
    SCRIPT=${0:a}
    SCRIPTPATH=${0:a:h}
fi
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

    init_git_config 

    VIM_CONFIG=y
    init_vim_config
    echo "export VIM_CONFIG=$VIM_CONFIG" >> "$1"

    TMUX_CONFIG=y
    init_tmux_config
    echo "export TMUX_CONFIG=$TMUX_CONFIG" >> "$1"

}

init_git_config()
{
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
    
    ln -s "$SCRIPTPATH/vim/vimrc" "$HOME/.vimrc"
    ln -s "$SCRIPTPATH/vim/vim" "$HOME/.vim"
    #vim +PlugInstall +qall
}

init_tmux_config()
{
    if [ -f "$HOME/.tmux.conf" ]; then
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.old"
    fi
    
    ln -s "$SCRIPTPATH/tmux/tmux.conf" "$HOME/.tmux.conf"
}

#######################################################
# Basic config
export TERM="xterm-256color"
export PATH=$PATH:$SCRIPTPATH/bin
export PATH=$PATH:$SCRIPTPATH/depot_tools
export MANPATH=$SCRIPTPATH/man:$MANPATH

export DEPOT_TOOLS_UPDATE=0

alias viminit='vim $SCRIPT'
alias sourceinit='source $SCRIPT'

load_script "$INIT_CONFIG_FILE"
if [ $INITING = 1 ]; then 
    init_config "$INIT_CONFIG_FILE"
fi

######################################################
# Expert config
export HISTTIMEFORMAT="%Y-%m-%d %T "

#export PATH=$SCRIPTPATH/p4merge/bin:$PATH
export PATH=$PATH:$SCRIPTPATH/ripgrep
export PATH=$PATH:$SCRIPTPATH/fd/usr/bin
export PATH=$PATH:$SCRIPTPATH/ncdu
export MANPATH=$SCRIPTPATH/ncdu:$MANPATH
export PATH=$PATH:$SCRIPTPATH/pet

alias e=vim
alias v=vim
alias rg-c1='rg -C 1 -F'
alias tmux='tmux -2'
alias rg-oneline='rg --no-filename --no-heading -H -F'
alias rg-all='rg --follow --hidden --no-ignore'
alias em='emacs -nw'
alias fd-all='fd -HIL'
alias fzfp="fzf --preview 'cat {}'"
alias adb_start_app="adb shell am start -p" #<package_name>
alias adb_stop_app="adb shell am force-stop" #<package_name>
alias adb_list_app="adb shell ps -A | grep -v root"

# http test
# sudo snap install insomnia 

# screenshot
# sudo apt install flameshot

# diff/merge tool
# sudo apt install meld

if [ "$IS_BASH" = 1 ]; then
    source $SCRIPTPATH/git/git-prompt.sh
    PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\[\033[36m\]$(__git_ps1) \[\e[90m\]$(date "+%H:%M:%S")\[\033[0m\]\n\$ '

    source $SCRIPTPATH/ripgrep/complete/rg.bash-completion
    source $SCRIPTPATH/tmux/tmux.bash-completion
    source $SCRIPTPATH/fd/usr/share/bash-completion/completions/fd
    source $SCRIPTPATH/share/bash-completion/completions/ffmpeg
elif [ $IS_ZSH = 1 ]; then
    source $SCRIPTPATH/git/git-prompt.sh
    setopt PROMPT_SUBST
    PS1=$'\n%F{green}%n@%m%f %F{yellow}%~%f %F{cyan}$(__git_ps1 "(%s)")%f \n$ '
fi

if [ $VIM_CONFIG = y ]; then
 
    if [ "$IS_BASH" = 1 ]; then
        complete -F _fzf_path_completion -o default -o bashdefault rg
        complete -F _fzf_path_completion -o default -o bashdefault chromeos-dd
        complete -F _fzf_path_completion -o default -o bashdefault chromeos-install

        # alt + e : select pet snipet
        bind -x '"\ee": pet-select'
    fi
    
    # use fd to list file
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    # show fzf iniine
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
    # To apply the command to CTRL-T as well
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    # To apply the command to ALT-C as well
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
    
    
    # Use fd (https://github.com/sharkdp/fd) instead of the default find
    # command for listing path candidates.
    # - The first argument to the function ($1) is the base path to start traversal
    # - See the source code (completion.{bash,zsh}) for the details.
    _fzf_compgen_path() {
      fd --hidden --follow --exclude ".git" . "$1"
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi

function pet-select() {
  BUFFER=$(pet search --query "$READLINE_LINE")
  READLINE_LINE=$BUFFER
  READLINE_POINT=${#BUFFER}
}

if [ "$IS_BASH" = 1 ]; then
    funcs()
    {
      local cur
      cur=${COMP_WORDS[COMP_CWORD]}
      COMPREPLY=(`global -c $cur`)
    }
    # complete -F funcs global
fi

if [ -f $SCRIPTPATH/.initrc ]; then
    . $SCRIPTPATH/.initrc
fi

