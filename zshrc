export ZSH=~/.oh-my-zsh
export SCRIPTS=$HOME/scripts
export NPM_PACKAGES=$HOME/.npm-packages/bin
export LOCAL_BIN=$HOME/.local/bin
export PATH=$PATH:$SCRIPTS:$NPM_PACKAGES:$LOCAL_BIN
export EDITOR='vim'

export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

autoload -Uz promptinit
promptinit

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

plugins=(git zsh-syntax-highlighting virtualenv)
export VIRTUAL_ENV_DISABLE_PROMPT=0

source $ZSH/oh-my-zsh.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

alias fucking='sudo'
source /usr/share/nvm/init-nvm.sh
