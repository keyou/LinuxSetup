if not status is-interactive
  exit 0
end

# Commands to run in interactive sessions can go here
echo "load keyou fish init v22.11.26"

# disable bash flow control(C-s/C-q)
stty -ixon

# disable terminal exit with C-d
# set -o ignoreeof

stty werase undef

# disalbe fish welcome
set -g fish_greeting

# use fd to list file
set -gx FZF_DEFAULT_COMMAND 'fd --no-ignore --type f --hidden --follow --exclude .git'
# show fzf iniine
set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse'
# To apply the command to CTRL-T as well
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
# To apply the command to ALT-C as well
set -gx FZF_ALT_C_COMMAND "$FZF_DEFAULT_COMMAND"

