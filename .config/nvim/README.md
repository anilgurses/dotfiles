# Neovim Config

This config uses `lazy.nvim` and keeps plugin specs in `lua/user/*.lua`.
The notes below are based on the current config in `lua/user/*.lua`, `lua/keymaps.lua`, and buffer-local LSP/NvimTree mappings.

`<leader>` is `Space`.

## Plugin List

### UI and Navigation

- `ellisonleao/gruvbox.nvim`: main colorscheme.
- `goolord/alpha-nvim`: startup dashboard.
- `folke/which-key.nvim`: keymap hint popup for leader mappings.
- `nvim-lualine/lualine.nvim`: statusline.
- `akinsho/bufferline.nvim`: buffer tabs.
- `famiu/bufdelete.nvim`: buffer deletion without breaking window layout.
- `kyazdani42/nvim-tree.lua`: file explorer sidebar.
- `nvim-tree/nvim-web-devicons`: file icons.
- `nvim-telescope/telescope.nvim`: fuzzy finder and search UI.
- `nvim-telescope/telescope-fzf-native.nvim`: native sorter for Telescope.
- `nvim-lua/plenary.nvim`: utility dependency used by Telescope and other plugins.
- `ahmedkhalf/project.nvim`: project root detection and Telescope project picker.
- `LunarVim/breadcrumbs.nvim`: code breadcrumbs.
- `lukas-reineke/indent-blankline.nvim`: indent guides.
- `folke/noice.nvim`: improved command-line and message UI.
- `MunifTanjim/nui.nvim`: UI dependency for Noice and LeetCode.
- `rcarriga/nvim-notify`: notifications.
- `rmagatti/auto-session`: session save/restore.
- `ethanholz/nvim-lastplace`: restore cursor position when reopening files.

### Editing and Completion

- `saghen/blink.cmp`: completion engine.
- `rafamadriz/friendly-snippets`: snippet collection for completion.
- `windwp/nvim-autopairs`: auto-insert matching brackets and quotes.
- `numToStr/Comment.nvim`: comment toggling.
- `JoosepAlviste/nvim-ts-context-commentstring`: filetype-aware comment strings.
- `junegunn/vim-easy-align`: interactive alignment.
- `github/copilot.vim`: Copilot suggestions.
- `kkoomen/vim-doge`: docblock generation.
- `vim-scripts/DoxygenToolkit.vim`: Doxygen helpers for C/C++.

### Code Intelligence and Tooling

- `neovim/nvim-lspconfig`: LSP client configuration.
- `williamboman/mason.nvim`: external LSP/tool installer.
- `williamboman/mason-lspconfig.nvim`: Mason bridge for `lspconfig`.
- `nvimtools/none-ls.nvim`: formatters, completion, and code actions.
- `nvim-treesitter/nvim-treesitter`: syntax highlighting and indentation from parsers.
- `ludovicchabant/vim-gutentags`: automatic ctags generation.
- `lewis6991/gitsigns.nvim`: git signs and blame.
- `liuchengxu/vista.vim`: symbol outline.
- `mfussenegger/nvim-dap`: debugger integration.
- `rcarriga/nvim-dap-ui`: debugger UI.

### Language and Utility Plugins

- `lervag/vimtex`: LaTeX workflow.
- `bfrg/vim-cpp-modern`: modern C++ highlighting.
- `kawre/leetcode.nvim`: LeetCode integration.
- `akinsho/toggleterm.nvim`: floating terminal.
- `folke/todo-comments.nvim`: highlight TODO/FIXME/NOTE comments.
- `wakatime/vim-wakatime`: coding activity tracking.

## Important Keymaps

### Core

- `jk` in insert mode: leave insert mode.
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: move between windows.
- `<C-Up>`, `<C-Down>`, `<C-Left>`, `<C-Right>`: resize splits.
- `<S-h>`, `<S-l>`: previous/next buffer.
- `<S-q>`: close current buffer.
- `<leader>q`: quit all after cleaning terminal buffers.
- `<leader>h`: clear search highlight.

### Search and Project Navigation

- `<leader>ff`: Telescope file search.
- `<leader>ft`: Telescope live grep.
- `<leader>fp`: Telescope project picker.
- `<leader>fb`: Telescope buffers.
- `<leader>fr`: Telescope recent files.
- `<leader>fl`: resume last Telescope picker.
- `<leader>fh`: Telescope help tags.
- Inside Telescope: `<C-j>` and `<C-k>` move selection, `<C-n>` and `<C-p>` cycle search history, `<Esc>` or `q` closes in normal mode.

### File Tree

- `<leader>e`: toggle NvimTree.
- Inside NvimTree:
- `l`, `o`, `<CR>`: open file.
- `h`: close directory / go to parent.
- `v`: open in vertical split.
- `a`: create file or directory.
- `d`: delete.
- `r`: rename.
- `H`: toggle dotfiles.
- `I`: toggle gitignored files.

### LSP

- `gd`: go to definition.
- `gD`: go to declaration.
- `gI`: go to implementation.
- `gr`: list references.
- `K`: hover documentation.
- `gl`: line diagnostics popup.
- `<leader>la`: code action.
- `<leader>lr`: rename symbol.
- `<leader>lf`: format buffer.
- `<leader>ls`: signature help.
- `<leader>lj`, `<leader>lk`: next/previous diagnostic.
- `<leader>lq`: push diagnostics to the location list.
- `<leader>li`: `LspInfo`.
- `<leader>lI`: `Mason`.

### Git, Terminal, and Debugging

- `<leader>gg`: toggle Lazygit terminal.
- `<leader>t`: toggle floating terminal.
- `<C-\\>`: ToggleTerm open mapping.
- `<leader>db`: toggle breakpoint.
- `<leader>dc`: continue.
- `<leader>di`: step into.
- `<leader>do`: step over.
- `<leader>dO`: step out.
- `<leader>dr`: toggle DAP REPL.
- `<leader>dl`: run last debug session.
- `<leader>du`: toggle DAP UI.
- `<leader>dt`: terminate debugging.

### Editing Helpers

- `<leader>/`: toggle comments in normal or visual mode.
- `ga`: EasyAlign operator.
- `<M-e>`: autopairs fast wrap.
- `<C-J>` in insert mode: accept Copilot suggestion.

### Build and Run

- `<leader>fs`: write file.
- `<leader>fc`: start `:w` with a custom target/path.
- `<leader>bd`: run `:BuildInContainer`.
- `<leader>br`: open build logs with `:BuildContainerLogs`.
- `<leader>bl`: set background to light.
- `<leader>rp`: save and run current Python file with `python3`.
- `<leader>rpa`: save and run current Python file with custom args.
- `<leader>v`: toggle Vista outline.

## Notes

- `which-key` is enabled, so pressing `<leader>` shows the available groups and mappings.
- `Mason` is configured for `lua_ls`, `html`, `pyright`, `bashls`, `jsonls`, `yamlls`, `clangd`, `cmake`, `dockerls`, `docker_compose_language_service`, and `opencl_ls`.
- `none-ls` enables `stylua`, `prettier`, and `black`, plus spell completion and gitsigns code actions.
- Some older mappings may still exist in the config, but this README only lists the ones that are part of the current active workflow.
