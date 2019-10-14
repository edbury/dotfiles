# Chrome OS Only
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

if ! (( $+commands[pbcopy] )); then
   alias pbcopy='xclip -selection clipboard'
fi

if ! (( $+commands[pbpaste] )); then
   alias pbpaste='xclip -selection clipboard -o'
fi

# Browser

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Language

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Source Antigen
source ~/dotfiles/antigen.zsh

# Antigen Bundles - oh-my-zsh
antigen use oh-my-zsh

antigen bundle git
antigen bundle gitfast
antigen bundle history
antigen bundle history-substring-search
antigen bundle npm
antigen bundle osx
antigen bundle wd

# Antigen Bundles - elsewhere
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting

# Antigen Theme
antigen theme sorin

# Tell antigen that we're done.
antigen apply

unsetopt AUTO_CD

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    eval "$("$BASE16_SHELL/profile_helper.sh")"


## Git
alias gdb='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d'

## Ctrl-Z Vim Swap
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

## ls / ll
alias ll='ls -lhFG'

## Brew Bundle
alias brewup='brew update; brew upgrade; brew cleanup; brew doctor'

## rbenv
eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/sbin:$PATH"
