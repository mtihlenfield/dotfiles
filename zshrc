export ZSH=~/.oh-my-zsh
export SCRIPTS=$HOME/scripts
export LOCAL_BIN=$HOME/.local/bin
export YABRIDGE=$HOME/.local/share/yabridge
export PATH=$PATH:$SCRIPTS:$LOCAL_BIN:$YABRIDGE
export PATH=$PATH:/usr/local/go/bin
export EDITOR='nvim'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

autoload -Uz promptinit
promptinit

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

# I think zsh-syntax-highlighting needs to be last
plugins=(git virtualenv zsh-syntax-highlighting)
export VIRTUAL_ENV_DISABLE_PROMPT=0

source $ZSH/oh-my-zsh.sh

alias keepass-diff='docker run -it --rm -v "$(pwd)":/app:ro "keepass-diff:custom-local"'
alias dns-search='dig +short'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "/home/strav/.ghcup/env" ] && . "/home/strav/.ghcup/env" # ghcup-env
