# Neovim Plugin Configuration

This directory contains modular plugin configurations for Neovim/LazyVim. Each file handles a specific aspect of the development environment.

## Plugin Files

### Core Development

- **`lsp.lua`** - Language Server Protocol configuration
  - TypeScript/JavaScript (tsserver)
  - HTML, CSS, JSON language servers
  - Nix language server (nil_ls)

### Code Quality

- **`formatting.lua`** - Code formatting with Prettier and ESLint
  - Auto-format on save
  - Multiple language support
- **`linting.lua`** - Code linting with ESLint
  - Real-time error detection
  - JavaScript/TypeScript focus

### AI Assistance

- **`copilot.lua`** - GitHub Copilot auto-completion

  - File type specific enabling
  - Custom keybindings (`Ctrl+J` to accept)

- **`copilot-chat.lua`** - GitHub Copilot Chat interface
  - Code explanation, review, optimization
  - Keybindings: `<leader>cc`, `<leader>ce`, etc.

### Web Development

- **`autotag.lua`** - Auto-closing HTML/JSX tags
  - Supports React, Vue, HTML, etc.

### Core Files

- **`treesitter.lua`** - Syntax highlighting configuration
- **`example.lua`** - LazyVim example (disabled)

## Usage

All files are automatically loaded by LazyVim. Plugins are lazy-loaded based on:

- File types
- Key bindings
- Insert mode entry
- Commands

## Keybindings

### Copilot Chat (`<leader>` = `<space>`)

- `<space>aa` - Toggle chat window
- `<space>ax` - Clear chat history
- `<space>aq` - Quick chat (type question)
- `<space>ap` - Prompt actions menu
- `Ctrl+S` - Submit prompt (in chat window)

### Copilot Auto-completion

- `Ctrl+J` - Accept suggestion
- `Alt+]` - Next suggestion
- `Alt+[` - Previous suggestion

## Adding New Plugins

1. Create a new `.lua` file in this directory
2. Return a table with plugin configurations
3. Follow the existing patterns for consistency
