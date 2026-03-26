# use volta for node instead of nvm. takes precedence over nvm
export PATH="$HOME/.volta/bin:$PATH"

# Ensure Homebrew-managed CLIs are on PATH on Apple Silicon macOS.
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# fix compdef errors
autoload -Uz compinit
compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source ~/github/experiments/ivanwang/dotfiles/scripts/chaws.shexport AWS_CONFIG_FILE=/Users/owusu.boateng/github/cloud/build_tools/aws_configs/cloud_config
# ~/.zshrc

# Find and set branch name var if in git repository.
function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo '- ('$branch')'
  fi
}

# Enable substitution in the prompt.
setopt prompt_subst

# Config for prompt. PS1 synonym.
prompt='%2/ $(git_branch_name) > '



for p10k_theme in \
  "$HOME/.nix-profile/share/zsh-powerlevel10k/powerlevel10k.zsh-theme" \
  "/etc/profiles/per-user/$USER/share/zsh-powerlevel10k/powerlevel10k.zsh-theme" \
  /nix/store/*-powerlevel10k-*/share/zsh-powerlevel10k/powerlevel10k.zsh-theme(N); do
  [[ -f "$p10k_theme" ]] && source "$p10k_theme" && break
done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -f /Users/owusu.boateng/.config/zipline/env ]] && source /Users/owusu.boateng/.config/zipline/env

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt hist_fcntl_lock
setopt share_history
setopt no_append_history
setopt no_extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt no_hist_find_no_dups
setopt no_hist_ignore_all_dups
setopt no_hist_save_no_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- Eza (better ls) -----

alias ls="eza --icons=always"
alias la="eza -a"
alias ll="eza -l"
alias lla="eza -la"
alias lt="eza --tree"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"


# kubectl aliases
# alias k='bin/kubectl'
# alias kctx-staging='kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-staging'
# alias kctx-prod='kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-production'
# alias kctx-preprod='kubectl config use-context arn:aws:eks:us-west-2:676657780981:cluster/primary-preprod'

# alias chaws='~/github/cloud/bin/kubectl env'
# alias kns='~/github/cloud/bin/kubectl ns'


# KUBECTL ALIASES #
alias k='kubectl'
alias kdata='kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-data'
alias kpre='kubectl config use-context arn:aws:eks:us-west-2:676657780981:cluster/primary-preprod'
alias kstage='kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-staging'
alias kprod='kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-production'
alias awspre='export AWS_PROFILE=preprod'
alias awsprod='export AWS_PROFILE=prod'
alias awsdata='export AWS_PROFILE=data'
alias awslogin='aws sso login'

# git aliases
alias unfuck='git reset HEAD~1 --soft'
alias unstage='git reset HEAD --'
alias uncommit='git reset HEAD~1 --soft'
alias recommit='git commit --amend --no-edit'
alias get='git pull origin'
alias push='git push origin HEAD'
alias commit='git commit -m'
alias add='git add -p'
alias log='git log --graph --all --pretty="format:%C(auto)%h %C(cyan)%ar %C(auto)%d %C(magenta)%an %C(auto)%s"'
alias cd=z

# Open macOS GUI apps from Terminal, e.g. `app "Visual Studio Code"`
app() {
  open -a "$*"
}

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/owusu.boateng/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"
eval "$(direnv hook zsh)"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/owusu.boateng/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
[[ $commands[kubectl] ]] && source <(kubectl completion zsh) # add autocomplete permanently to your zsh shell

# Load interactive Zsh plugins after completions and hooks so highlighting works reliably.
for zsh_autosuggestions in \
  "$HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/etc/profiles/per-user/$USER/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /nix/store/*-zsh-autosuggestions-*/share/zsh-autosuggestions/zsh-autosuggestions.zsh(N); do
  [[ -f "$zsh_autosuggestions" ]] && source "$zsh_autosuggestions" && break
done

for zsh_syntax_highlighting in \
  "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/etc/profiles/per-user/$USER/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  /nix/store/*-zsh-syntax-highlighting-*/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(N); do
  [[ -f "$zsh_syntax_highlighting" ]] && source "$zsh_syntax_highlighting" && break
done

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[function]='fg=green'
