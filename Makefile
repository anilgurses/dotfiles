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

ZSHRC_SRC := $(DOTFILES_DIR)/.zshrc
ZSHRC_DEST ?= $(HOME)/.zshrc

TMUX_CONF_SRC := $(DOTFILES_DIR)/.tmux.conf
TMUX_CONF_DEST ?= $(HOME)/.tmux.conf
TMUX_DIR_SRC := $(DOTFILES_DIR)/.tmux
TMUX_DIR_DEST ?= $(HOME)/.tmux

NVIM_DIR_SRC := $(DOTFILES_DIR)/.config/nvim
NVIM_DIR_DEST ?= $(HOME)/.config/nvim

.PHONY: help install install-linux install-mac install-common \
	install-alias-linux install-alias-mac install-zshrc install-tmux install-nvim \
	uninstall uninstall-common uninstall-alias-linux uninstall-alias-mac uninstall-zshrc \
	uninstall-tmux uninstall-nvim \
	install-deps install-deps-linux install-deps-mac create-venv

help:
	@printf '%s\n' \
		'Targets:' \
		'  install            Install for the current OS (macOS or Linux)' \
		'  install-linux      Install Linux dotfiles' \
		'  install-mac        Install macOS dotfiles' \
		'  install-zshrc      Install .zshrc' \
		'  install-tmux       Install tmux config' \
		'  install-nvim       Install Neovim config' \
		'  install-deps       Install dependencies for the current OS' \
		'  create-venv        Create a Python venv for dotfiles' \
		'  uninstall          Remove OS-specific installs' \
		'  uninstall-zshrc    Remove .zshrc symlink' \
		'  uninstall-tmux     Remove tmux symlinks' \
		'  uninstall-nvim     Remove Neovim symlink' \
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

install-common: install-zshrc install-tmux install-nvim

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

install-zshrc:
	@if [ -e "$(ZSHRC_DEST)" ] && [ ! -L "$(ZSHRC_DEST)" ]; then \
		mkdir -p "$(BACKUP_DIR)"; \
		ts=$$(date +%Y%m%d%H%M%S); \
		mv "$(ZSHRC_DEST)" "$(BACKUP_DIR)/$$(basename "$(ZSHRC_DEST)").$${ts}.bak"; \
		printf 'Backed up %s -> %s\n' "$(ZSHRC_DEST)" "$(BACKUP_DIR)"; \
	fi
	@ln -sfn "$(ZSHRC_SRC)" "$(ZSHRC_DEST)"
	@printf 'Linked %s -> %s\n' "$(ZSHRC_SRC)" "$(ZSHRC_DEST)"

install-tmux:
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
	@if [ ! -d "$(TMUX_DIR_DEST)/plugins/tpm/.git" ]; then \
		if command -v git >/dev/null 2>&1; then \
			mkdir -p "$(TMUX_DIR_DEST)/plugins"; \
			git clone https://github.com/tmux-plugins/tpm "$(TMUX_DIR_DEST)/plugins/tpm"; \
		else \
			printf 'git not found; cannot install tmux plugin manager\n'; \
			exit 1; \
		fi; \
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

install-deps:
	@if [ "$(OS)" = "Darwin" ]; then \
		$(MAKE) install-deps-mac; \
	elif [ "$(OS)" = "Linux" ]; then \
		$(MAKE) install-deps-linux; \
	else \
		printf 'Unsupported OS: %s\n' "$(OS)"; \
		exit 1; \
	fi

install-deps-mac:
	@command -v brew >/dev/null 2>&1 || { printf 'Homebrew not found\n'; exit 1; }
	@brew install python@$(PYTHON_VERSION) pyenv tmux neovim ripgrep fzf
	@if ! command -v pyenv >/dev/null 2>&1; then \
		if command -v curl >/dev/null 2>&1; then \
			curl -fsSL https://pyenv.run | bash; \
		else \
			printf 'pyenv not installed; curl not found for pyenv.run\n'; \
			exit 1; \
		fi; \
	fi
	@printf 'Installed macOS dependencies\n'

install-deps-linux:
	@if command -v dnf >/dev/null 2>&1; then \
		sudo dnf install -y --skip-unavailable \
			python$(PYTHON_VERSION) python3-pip python3-virtualenv pyenv \
			tmux neovim ripgrep fzf; \
		sudo dnf install -y wl-clipboard || sudo dnf install -y xclip; \
		if ! command -v pyenv >/dev/null 2>&1; then \
			if command -v curl >/dev/null 2>&1; then \
				curl -fsSL https://pyenv.run | bash; \
			else \
				printf 'pyenv not installed; curl not found for pyenv.run\n'; \
				exit 1; \
			fi; \
		fi; \
	elif command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update; \
		if apt-cache show python$(PYTHON_VERSION) >/dev/null 2>&1; then \
			sudo apt-get install -y python$(PYTHON_VERSION) python$(PYTHON_VERSION)-venv; \
		else \
			sudo apt-get install -y python3 python3-venv; \
		fi; \
		sudo apt-get install -y python3-pip tmux neovim ripgrep fzf; \
		if ! command -v pyenv >/dev/null 2>&1; then \
			if command -v curl >/dev/null 2>&1; then \
				curl -fsSL https://pyenv.run | bash; \
			else \
				printf 'pyenv not installed; curl not found for pyenv.run\n'; \
				exit 1; \
			fi; \
		fi; \
		sudo apt-get install -y wl-clipboard || sudo apt-get install -y xclip; \
	else \
		printf 'No supported package manager found (dnf/apt-get)\n'; \
		exit 1; \
	fi
	@printf 'Installed Linux dependencies\n'

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

uninstall-common: uninstall-zshrc uninstall-tmux uninstall-nvim

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
