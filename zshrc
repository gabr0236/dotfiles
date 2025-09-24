# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi





# terminal history
export HISTFILE=~/.zsh_history
export HISTSIZE=100000 # events kept in memory
export SAVEHIST=100000 # events saved to HISTFILE on session end
# make sure these options are set so history is appended and shared:
setopt APPEND_HISTORY        # add new entries to the history file, don't overwrite
setopt INC_APPEND_HISTORY    # write each command as you type it
setopt SHARE_HISTORY         # share history across all running shells
setopt HIST_IGNORE_ALL_DUPS  # ignore duplicates
setopt HIST_IGNORE_SPACE     # ignore space
setopt EXTENDED_HISTORY      # record timestamps

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export PATH="$PATH:/Users/gabriel/.dotnet/tools"

zstyle ':omz:update' frequency 10

COMPLETION_WAITING_DOTS="true"

plugins=(
 git
 history
 web-search
)

source $ZSH/oh-my-zsh.sh

# User configuration #

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pretty git log --oneline
alias glo='git log --pretty=format:"%C(yellow)%h %Cblue%>(12,trunc)%ad %Cgreen%<(10,trunc)%aN %C(auto,reset)%s%C(auto,red)% gD% D" --date=relative'

# consensus, FE build out of memory
export NODE_OPTIONS=--max_old_space_size=16384;

export PATH=$PATH:'/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
export GIT_EDITOR='vim'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.13/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gabriel/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gabriel/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gabriel/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gabriel/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
