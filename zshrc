export ZSH=~/.oh-my-zsh
export SCRIPTS=$HOME/scripts
export LOCAL_BIN=$HOME/.local/bin
export HEXEDITOR=/opt/010editor
export GRADLE=/opt/gradle-6.7.1/bin
export PATH=$PATH:$SCRIPTS:$LOCAL_BIN:$HEXEDITOR:$GRADLE
export EDITOR='vim'

autoload -Uz promptinit
promptinit

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions virtualenv)
export VIRTUAL_ENV_DISABLE_PROMPT=0

source $ZSH/oh-my-zsh.sh

alias keepass-diff='docker run -it --rm -v "$(pwd)":/app:ro "keepass-diff:custom-local"'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
