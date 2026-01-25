export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="simple"

plugins=(git fzf docker)

source $ZSH/oh-my-zsh.sh

export PATH=~/.npm-global/bin:/opt/ltx/bin/:$PATH
export PATH=/home/agrses/.local/bin/:$PATH:/usr/local/cuda-12.1/bin:/home/agrses/.cargo/bin:/home/agrses/go/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib64
export NVM_DIR="$HOME/.nvm"
export UHD_IMAGES_DIR=/usr/local/share/uhd/images

# Lazy load NVM
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
 
node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  node "$@"
}
 
npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npm "$@"
}

npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npx "$@"
}

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib/python3.11/site-packages/nvidia/cudnn/lib/:/usr/lib64/
export EDITOR=nvim 
export VISUAL=nvim

source $HOME/.scripts/shortcuts.sh

# pnpm
export PNPM_HOME="/home/agrses/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
gpgconf --launch gpg-agent
gpg-connect-agent /bye
export GPG_TTY=$(tty)
echo UPDATESTARTUPTTY | gpg-connect-agent > /dev/null

if [ -f "$HOME/.scripts/.env" ]; then
    source "$HOME/.scripts/.env"
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# opencode
export PATH=/home/agrses/.opencode/bin:$PATH

. "$HOME/.local/bin/env"
# Optimized uv completion
if [ -f "$HOME/.uv_completion.zsh" ]; then
    source "$HOME/.uv_completion.zsh"
fi
