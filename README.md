# tsc-errors.nvim

A lightweight Neovim plugin that collects TypeScript compiler errors and populates the quickfix list for easy navigation.

## Features

- Runs TypeScript compiler and parses error output
- Populates quickfix list with error locations
- Provides a `:TSCErrors` command to check for errors
- Notifies when errors are found or when code is error-free

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "rafaelmian1/tsc-errors.nvim",
}
```

The plugin works out of the box with no configuration needed.

### Integration Examples

While no setup is required, you can customize the behavior by requiring the module and setting options:

#### With Telescope Integration

```lua
{
  "rafaelmian1/tsc-errors.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("tsc-errors").setup({
      qf_preview = function()
        require("telescope.builtin").quickfix()
      end,
    })
  end,
}
```

#### With fzf-lua Integration

```lua
{
  "rafaelmian1/tsc-errors.nvim",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  config = function()
    require("tsc-errors").setup({
      qf_preview = function()
        require("fzf-lua").quickfix()
      end,
    })
  end,
}
```

## Usage

After installation, use the `:TSCErrors` command to check for TypeScript errors. When errors are found, they'll be displayed in the quickfix list.

You can also map this command to a key for quicker access:

```lua
vim.keymap.set('n', '<leader>ce', ':TSCErrors<CR>', { silent = true })
```

## Configuration (Optional)

The plugin works without configuration, but you can customize it with:

```lua
require("tsc-errors").setup({
  -- Default values shown
  key = "<leader>tsce",                   -- Custom keybinding (in addition to :TSCErrors)
  qf_preview = function() vim.cmd("copen") end,  -- Function to open quickfix list
  tsc_cmd = "npx tsc --noEmit",           -- TypeScript compiler command
  qf_title = "TSC compile errors"         -- Title for the quickfix list
})
```

## API

The plugin provides the following public functions:

### `tsc_quickfix()`

Runs the TypeScript compiler, populates the quickfix list with errors, and shows them if any are found.

```lua
require("tsc-errors").tsc_quickfix()
```

## License

MIT
