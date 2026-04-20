SHELL := /bin/sh

DOTFILES_DIR := $(CURDIR)
OS := $(shell uname -s)

ALIAS_SRC := $(DOTFILES_DIR)/alias.sh
ALIAS_DEST_LINUX ?= $(HOME)/.zsh_aliases
ALIAS_DEST_MAC ?= $(HOME)/.zsh_aliases

PYTHON_VERSION ?= 3.11
PYTHON_BIN ?= python$(PYTHON_VERSION)
VENV_DIR ?= $(HOME)/.venvs/dotfiles
BACKUP_DIR ?= $(HOME)/.dotfiles_backup

BREW_PACKAGES := git curl python@$(PYTHON_VERSION) pyenv tmux neovim ripgrep fzf fd lazygit node cmake unzip
BREW_CASKS := alacritty basictex
DNF_PACKAGES := git curl zsh tmux neovim ripgrep fzf make gcc gcc-c++ cmake nodejs npm unzip tar gzip python3-pip python3-virtualenv
DNF_LATEX_PACKAGES := texlive-scheme-basic texlive-collection-latexextra latexmk okular
APT_PACKAGES := git curl zsh tmux neovim ripgrep fzf build-essential cmake nodejs npm unzip python3-pip
APT_LATEX_PACKAGES := texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-pictures latexmk okular

OH_MY_ZSH_DIR ?= $(HOME)/.oh-my-zsh
ZSHRC_SRC := $(DOTFILES_DIR)/.zshrc
ZSHRC_DEST ?= $(HOME)/.zshrc

TMUX_CONF_SRC := $(DOTFILES_DIR)/.tmux.conf
TMUX_CONF_DEST ?= $(HOME)/.tmux.conf
TMUX_DIR_SRC := $(DOTFILES_DIR)/.tmux
TMUX_DIR_DEST ?= $(HOME)/.tmux
TPM_DIR ?= $(TMUX_DIR_DEST)/plugins/tpm

NVIM_DIR_SRC := $(DOTFILES_DIR)/.config/nvim
NVIM_DIR_DEST ?= $(HOME)/.config/nvim

GIT_IGNORE_SRC := $(DOTFILES_DIR)/.config/git/ignore
GIT_IGNORE_DEST ?= $(HOME)/.config/git/ignore
GIT_USER_NAME ?= Anil Gurses

.PHONY: help install install-linux install-mac install-common \
	install-alias-linux install-alias-mac install-oh-my-zsh install-zshrc install-tmux install-tpm install-nvim install-git-config \
	uninstall uninstall-common uninstall-alias-linux uninstall-alias-mac uninstall-zshrc \
	uninstall-tmux uninstall-nvim uninstall-git-config \
	install-deps install-deps-linux install-deps-mac install-deps-brew install-deps-dnf install-deps-apt \
	install-pyenv create-venv

help:
	@printf '%s\n' \
		'Targets:' \
		'  install            Install for the current OS (macOS or Linux)' \
		'  install-linux      Install Linux dotfiles' \
		'  install-mac        Install macOS dotfiles' \
		'  install-oh-my-zsh  Install Oh My Zsh to $(OH_MY_ZSH_DIR)' \
		'  install-zshrc      Install .zshrc' \
		'  install-tmux       Install tmux config' \
		'  install-tpm        Install tmux plugin manager to $(TPM_DIR)' \
		'  install-nvim       Install Neovim config' \
		'  install-git-config Install git global config' \
		'  install-deps       Install dependencies for the current OS' \
		'  install-deps-brew  Install macOS dependencies with Homebrew' \
		'  install-deps-dnf   Install dependencies with dnf' \
		'  install-deps-apt   Install dependencies with apt' \
		'  create-venv        Create a Python venv for dotfiles' \
		'  uninstall          Remove OS-specific installs' \
		'  uninstall-zshrc    Remove .zshrc symlink' \
		'  uninstall-tmux     Remove tmux symlinks' \
		'  uninstall-nvim     Remove Neovim symlink' \
		'  uninstall-git-config Remove git ignore symlink' \
		'' \
		'Notes:' \
		"  Linux aliases -> $(ALIAS_DEST_LINUX)" \
		"  macOS aliases -> $(ALIAS_DEST_MAC)"

install:
	@if [ "$(OS)" = "Darwin" ]; then \
		$(MAKE) install-mac; \
	elif [ "$(OS)" = "Linux" ]; then \
		$(MAKE) install-linux; \
	else \
		printf 'Unsupported OS: %s\n' "$(OS)"; \
		exit 1; \
	fi

install-linux: install-common install-alias-linux

install-mac: install-common install-alias-mac

install-common: install-oh-my-zsh install-zshrc install-tmux install-nvim install-git-config

install-alias-linux:
	@if [ -e "$(ALIAS_DEST_LINUX)" ] && [ ! -L "$(ALIAS_DEST_LINUX)" ]; then \
		mkdir -p "$(BACKUP_DIR)"; \
		ts=$$(date +%Y%m%d%H%M%S); \
		mv "$(ALIAS_DEST_LINUX)" "$(BACKUP_DIR)/$$(basename "$(ALIAS_DEST_LINUX)").$${ts}.bak"; \
		printf 'Backed up %s -> %s\n' "$(ALIAS_DEST_LINUX)" "$(BACKUP_DIR)"; \
	fi
	@ln -sfn "$(ALIAS_SRC)" "$(ALIAS_DEST_LINUX)"
	@printf 'Linked %s -> %s\n' "$(ALIAS_SRC)" "$(ALIAS_DEST_LINUX)"

install-alias-mac:
	@if [ -e "$(ALIAS_DEST_MAC)" ] && [ ! -L "$(ALIAS_DEST_MAC)" ]; then \
		mkdir -p "$(BACKUP_DIR)"; \
		ts=$$(date +%Y%m%d%H%M%S); \
		mv "$(ALIAS_DEST_MAC)" "$(BACKUP_DIR)/$$(basename "$(ALIAS_DEST_MAC)").$${ts}.bak"; \
		printf 'Backed up %s -> %s\n' "$(ALIAS_DEST_MAC)" "$(BACKUP_DIR)"; \
	fi
	@ln -sfn "$(ALIAS_SRC)" "$(ALIAS_DEST_MAC)"
	@printf 'Linked %s -> %s\n' "$(ALIAS_SRC)" "$(ALIAS_DEST_MAC)"

install-oh-my-zsh:
	@if [ ! -d "$(OH_MY_ZSH_DIR)" ]; then \
		if ! command -v git >/dev/null 2>&1; then \
			printf 'git not found; cannot install Oh My Zsh\n'; \
			exit 1; \
		fi; \
		git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$(OH_MY_ZSH_DIR)"; \
		printf 'Installed Oh My Zsh to %s\n' "$(OH_MY_ZSH_DIR)"; \
	elif [ -d "$(OH_MY_ZSH_DIR)/.git" ]; then \
		printf 'Oh My Zsh already installed at %s\n' "$(OH_MY_ZSH_DIR)"; \
	else \
		printf '%s exists and is not an Oh My Zsh git checkout; refusing to overwrite\n' "$(OH_MY_ZSH_DIR)"; \
		exit 1; \
	fi

install-zshrc:
	@if [ -e "$(ZSHRC_DEST)" ] && [ ! -L "$(ZSHRC_DEST)" ]; then \
		mkdir -p "$(BACKUP_DIR)"; \
		ts=$$(date +%Y%m%d%H%M%S); \
		mv "$(ZSHRC_DEST)" "$(BACKUP_DIR)/$$(basename "$(ZSHRC_DEST)").$${ts}.bak"; \
		printf 'Backed up %s -> %s\n' "$(ZSHRC_DEST)" "$(BACKUP_DIR)"; \
	fi
	@ln -sfn "$(ZSHRC_SRC)" "$(ZSHRC_DEST)"
	@printf 'Linked %s -> %s\n' "$(ZSHRC_SRC)" "$(ZSHRC_DEST)"

install-tmux: install-tpm
	@if [ -e "$(TMUX_CONF_DEST)" ] && [ ! -L "$(TMUX_CONF_DEST)" ]; then \
		mkdir -p "$(BACKUP_DIR)"; \
		ts=$$(date +%Y%m%d%H%M%S); \
		mv "$(TMUX_CONF_DEST)" "$(BACKUP_DIR)/$$(basename "$(TMUX_CONF_DEST)").$${ts}.bak"; \
		printf 'Backed up %s -> %s\n' "$(TMUX_CONF_DEST)" "$(BACKUP_DIR)"; \
	fi
	@if [ -e "$(TMUX_DIR_DEST)" ] && [ ! -L "$(TMUX_DIR_DEST)" ]; then \
		mkdir -p "$(BACKUP_DIR)"; \
		ts=$$(date +%Y%m%d%H%M%S); \
		mv "$(TMUX_DIR_DEST)" "$(BACKUP_DIR)/$$(basename "$(TMUX_DIR_DEST)").$${ts}.bak"; \
		printf 'Backed up %s -> %s\n' "$(TMUX_DIR_DEST)" "$(BACKUP_DIR)"; \
	fi
	@ln -sfn "$(TMUX_CONF_SRC)" "$(TMUX_CONF_DEST)"
	@ln -sfn "$(TMUX_DIR_SRC)" "$(TMUX_DIR_DEST)"
	@printf 'Linked %s -> %s\n' "$(TMUX_CONF_SRC)" "$(TMUX_CONF_DEST)"
	@printf 'Linked %s -> %s\n' "$(TMUX_DIR_SRC)" "$(TMUX_DIR_DEST)"

install-tpm:
	@if [ ! -d "$(TPM_DIR)/.git" ]; then \
		if ! command -v git >/dev/null 2>&1; then \
			printf 'git not found; cannot install tmux plugin manager\n'; \
			exit 1; \
		fi; \
		mkdir -p "$(dir $(TPM_DIR))"; \
		git clone https://github.com/tmux-plugins/tpm "$(TPM_DIR)"; \
		printf 'Installed tmux plugin manager at %s\n' "$(TPM_DIR)"; \
	else \
		printf 'tmux plugin manager already installed at %s\n' "$(TPM_DIR)"; \
	fi

install-nvim:
	@if [ -e "$(NVIM_DIR_DEST)" ] && [ ! -L "$(NVIM_DIR_DEST)" ]; then \
		mkdir -p "$(BACKUP_DIR)"; \
		ts=$$(date +%Y%m%d%H%M%S); \
		mv "$(NVIM_DIR_DEST)" "$(BACKUP_DIR)/$$(basename "$(NVIM_DIR_DEST)").$${ts}.bak"; \
		printf 'Backed up %s -> %s\n' "$(NVIM_DIR_DEST)" "$(BACKUP_DIR)"; \
	fi
	@mkdir -p "$(HOME)/.config"
	@ln -sfn "$(NVIM_DIR_SRC)" "$(NVIM_DIR_DEST)"
	@printf 'Linked %s -> %s\n' "$(NVIM_DIR_SRC)" "$(NVIM_DIR_DEST)"

install-git-config:
	@if [ -e "$(GIT_IGNORE_DEST)" ] && [ ! -L "$(GIT_IGNORE_DEST)" ]; then \
		mkdir -p "$(BACKUP_DIR)"; \
		ts=$$(date +%Y%m%d%H%M%S); \
		mv "$(GIT_IGNORE_DEST)" "$(BACKUP_DIR)/$$(basename "$(GIT_IGNORE_DEST)").$${ts}.bak"; \
		printf 'Backed up %s -> %s\n' "$(GIT_IGNORE_DEST)" "$(BACKUP_DIR)"; \
	fi
	@mkdir -p "$(dir $(GIT_IGNORE_DEST))"
	@ln -sfn "$(GIT_IGNORE_SRC)" "$(GIT_IGNORE_DEST)"
	@printf 'Linked %s -> %s\n' "$(GIT_IGNORE_SRC)" "$(GIT_IGNORE_DEST)"
	@if command -v git >/dev/null 2>&1; then \
		git config --global user.name "$(GIT_USER_NAME)"; \
		git config --global core.excludesfile "$(GIT_IGNORE_DEST)"; \
		printf 'Configured git user.name=%s\n' "$(GIT_USER_NAME)"; \
		printf 'Configured git core.excludesfile=%s\n' "$(GIT_IGNORE_DEST)"; \
	else \
		printf 'git not found; skipped git config updates\n'; \
	fi

install-deps:
	@if [ "$(OS)" = "Darwin" ]; then \
		$(MAKE) install-deps-brew; \
	elif [ "$(OS)" = "Linux" ]; then \
		$(MAKE) install-deps-linux; \
	else \
		printf 'Unsupported OS: %s\n' "$(OS)"; \
		exit 1; \
	fi

install-deps-mac:
	@$(MAKE) install-deps-brew

install-deps-linux:
	@if command -v dnf >/dev/null 2>&1; then \
		$(MAKE) install-deps-dnf; \
	elif command -v apt-get >/dev/null 2>&1; then \
		$(MAKE) install-deps-apt; \
	else \
		printf 'No supported package manager found (dnf/apt-get)\n'; \
		exit 1; \
	fi

install-deps-brew:
	@[ "$(OS)" = "Darwin" ] || { printf 'install-deps-brew is only supported on macOS\n'; exit 1; }
	@command -v brew >/dev/null 2>&1 || { printf 'Homebrew not found\n'; exit 1; }
	@brew install $(BREW_PACKAGES)
	@brew install --cask $(BREW_CASKS)
	@printf 'Installed dependencies with Homebrew\n'

install-deps-dnf:
	@command -v dnf >/dev/null 2>&1 || { printf 'dnf not found\n'; exit 1; }
	@sudo dnf install -y --skip-unavailable $(DNF_PACKAGES)
	@sudo dnf install -y --skip-unavailable $(DNF_LATEX_PACKAGES)
	@sudo dnf install -y "python$(PYTHON_VERSION)" || sudo dnf install -y python3
	@sudo dnf install -y pyenv || true
	@sudo dnf install -y fd-find || sudo dnf install -y fd || true
	@sudo dnf install -y lazygit || true
	@sudo dnf install -y alacritty || true
	@sudo dnf install -y wl-clipboard || sudo dnf install -y xclip || true
	@if ! command -v pyenv >/dev/null 2>&1; then \
		$(MAKE) install-pyenv; \
	fi
	@printf 'Installed dependencies with dnf\n'

install-deps-apt:
	@command -v apt-get >/dev/null 2>&1 || { printf 'apt-get not found\n'; exit 1; }
	@sudo apt-get update
	@if apt-cache show "python$(PYTHON_VERSION)" >/dev/null 2>&1; then \
		sudo apt-get install -y "python$(PYTHON_VERSION)" "python$(PYTHON_VERSION)-venv"; \
	else \
		sudo apt-get install -y python3 python3-venv; \
	fi
	@sudo apt-get install -y $(APT_PACKAGES)
	@sudo apt-get install -y $(APT_LATEX_PACKAGES)
	@if apt-cache show fd-find >/dev/null 2>&1; then \
		sudo apt-get install -y fd-find; \
	else \
		printf 'Skipping fd-find: package not available via apt\n'; \
	fi
	@if apt-cache show lazygit >/dev/null 2>&1; then \
		sudo apt-get install -y lazygit; \
	else \
		printf 'Skipping lazygit: package not available via apt\n'; \
	fi
	@if apt-cache show alacritty >/dev/null 2>&1; then \
		sudo apt-get install -y alacritty; \
	else \
		printf 'Skipping alacritty: package not available via apt\n'; \
	fi
	@if apt-cache show wl-clipboard >/dev/null 2>&1; then \
		sudo apt-get install -y wl-clipboard; \
	elif apt-cache show xclip >/dev/null 2>&1; then \
		sudo apt-get install -y xclip; \
	else \
		printf 'Skipping clipboard tools: neither wl-clipboard nor xclip is available via apt\n'; \
	fi
	@if ! command -v pyenv >/dev/null 2>&1; then \
		$(MAKE) install-pyenv; \
	fi
	@printf 'Installed dependencies with apt\n'

install-pyenv:
	@if command -v pyenv >/dev/null 2>&1; then \
		printf 'pyenv already installed\n'; \
	elif command -v curl >/dev/null 2>&1; then \
		curl -fsSL https://pyenv.run | bash; \
	else \
		printf 'pyenv not installed; curl not found for pyenv.run\n'; \
		exit 1; \
	fi

create-venv:
	@mkdir -p "$(dir $(VENV_DIR))"
	@"$(PYTHON_BIN)" -m venv "$(VENV_DIR)"
	@printf 'Created venv at %s\n' "$(VENV_DIR)"

uninstall:
	@if [ "$(OS)" = "Darwin" ]; then \
		$(MAKE) uninstall-common uninstall-alias-mac; \
	elif [ "$(OS)" = "Linux" ]; then \
		$(MAKE) uninstall-common uninstall-alias-linux; \
	else \
		printf 'Unsupported OS: %s\n' "$(OS)"; \
		exit 1; \
	fi

uninstall-common: uninstall-zshrc uninstall-tmux uninstall-nvim uninstall-git-config

uninstall-alias-linux:
	@if [ -L "$(ALIAS_DEST_LINUX)" ]; then rm -f "$(ALIAS_DEST_LINUX)"; fi
	@printf 'Removed %s\n' "$(ALIAS_DEST_LINUX)"

uninstall-alias-mac:
	@if [ -L "$(ALIAS_DEST_MAC)" ]; then rm -f "$(ALIAS_DEST_MAC)"; fi
	@printf 'Removed %s\n' "$(ALIAS_DEST_MAC)"

uninstall-zshrc:
	@if [ -L "$(ZSHRC_DEST)" ]; then rm -f "$(ZSHRC_DEST)"; fi
	@printf 'Removed %s\n' "$(ZSHRC_DEST)"

uninstall-tmux:
	@if [ -L "$(TMUX_CONF_DEST)" ]; then rm -f "$(TMUX_CONF_DEST)"; fi
	@if [ -L "$(TMUX_DIR_DEST)" ]; then rm -f "$(TMUX_DIR_DEST)"; fi
	@printf 'Removed %s\n' "$(TMUX_CONF_DEST)"
	@printf 'Removed %s\n' "$(TMUX_DIR_DEST)"

uninstall-nvim:
	@if [ -L "$(NVIM_DIR_DEST)" ]; then rm -f "$(NVIM_DIR_DEST)"; fi
	@printf 'Removed %s\n' "$(NVIM_DIR_DEST)"

uninstall-git-config:
	@if [ -L "$(GIT_IGNORE_DEST)" ]; then rm -f "$(GIT_IGNORE_DEST)"; fi
	@printf 'Removed %s\n' "$(GIT_IGNORE_DEST)"
