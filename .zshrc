# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Exports
export ZSH=$HOME/.oh-my-zsh
export LOCAL=$HOME/local
export PATH=$PATH:$LOCAL/bin:$LOCAL/nvim-osx64/bin
export EDITOR=nvim

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# Aliases
alias vim='nvim'
alias cpwd='pwd | xargs echo -n | pbcopy'
alias config='git --git-dir=$HOME/.configfiles/ --work-tree=$HOME'
alias ana='source $LOCAL/bin/conda_startup.sh && echo Anaconda activated'
alias todo='$EDITOR $HOME/.todo'

source $ZSH/oh-my-zsh.sh
cat $HOME/.todo
