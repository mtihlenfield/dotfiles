export ZSH=~/.oh-my-zsh
export SCRIPTS=$HOME/scripts
export NPM_PACKAGES=$HOME/.npm-packages/bin
export PATH=$PATH:$SCRIPTS:$NPM_PACKAGES
export EDITOR='vim'

export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

autoload -Uz promptinit
promptinit

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

alias fucking='sudo'
