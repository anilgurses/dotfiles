export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="simple"

plugins=(git fzf docker)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.npm-global/bin:/opt/ltx/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH:$HOME/.cargo/bin:$HOME/go/bin"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib64
export NVM_DIR="$HOME/.nvm"
export UHD_IMAGES_DIR=/usr/local/share/uhd/images

if [[ "$OSTYPE" != darwin* ]]; then
    if [ -d "/usr/local/cuda" ]; then
        export CUDA_HOME="/usr/local/cuda"
    else
        _latest_cuda_dir="$(printf '%s\n' /usr/local/cuda-[0-9]*(N) | sort -V | tail -n 1)"
        [ -n "$_latest_cuda_dir" ] && export CUDA_HOME="$_latest_cuda_dir"
        unset _latest_cuda_dir
    fi

    if [ -n "$CUDA_HOME" ]; then
        if [ -d "$CUDA_HOME/bin" ]; then
            case ":$PATH:" in
                *":$CUDA_HOME/bin:"*) ;;
                *) export PATH="$CUDA_HOME/bin:$PATH" ;;
            esac
        fi
        if [ -d "$CUDA_HOME/lib64" ]; then
            case ":$LD_LIBRARY_PATH:" in
                *":$CUDA_HOME/lib64:"*) ;;
                *) export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$CUDA_HOME/lib64" ;;
            esac
        fi
    fi
fi

# NVM
lazy_load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] || return 1

    unset -f nvm node npm npx pnpm corepack yarn yarnpkg
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}

nvm() { lazy_load_nvm && nvm "$@"; }
node() { lazy_load_nvm && node "$@"; }
npm() { lazy_load_nvm && npm "$@"; }
npx() { lazy_load_nvm && npx "$@"; }
pnpm() { lazy_load_nvm && pnpm "$@"; }
corepack() { lazy_load_nvm && corepack "$@"; }
yarn() { lazy_load_nvm && yarn "$@"; }
yarnpkg() { lazy_load_nvm && yarnpkg "$@"; }

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/
export EDITOR=nvim 
export VISUAL=nvim

if [ -f "$HOME/.scripts/shortcuts.sh" ]; then
    source "$HOME/.scripts/shortcuts.sh"
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#

export GPG_TTY="$(tty)"
if [ -S "$HOME/.gnupg/S.gpg-agent" ]; then
  export GPG_AGENT_INFO=
fi
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

if [ -f "$HOME/.scripts/.env" ]; then
    source "$HOME/.scripts/.env"
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init - zsh --no-rehash)"
fi

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi
# Optimized uv completion
if [ -f "$HOME/.uv_completion.zsh" ]; then
    source "$HOME/.uv_completion.zsh"
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
