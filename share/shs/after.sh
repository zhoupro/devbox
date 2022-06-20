#!/bin/bash

cat <<EOF > ~/.config/nvim/after/plugin/nvim-treesitter.rc.lua
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "go" },
    highlight = {
    enable = true,
    disable = {},
  },
  textobjects = {
      select = {
       enable = true,
       -- Automatically jump forward to textobj, similar to targets.vim-
       lookahead = false,
       keymaps = {
         ["af"] = "@function.outer",
       },
      },
    },
  }
EOF

cat <<EOF > ~/.config/nvim/after/plugin/lualine.rc.lua
   require('lualine').setup({
     options = {
        disabled_filetypes = {'NvimTree', 'VimspectorPrompt'}
     }
   })
EOF

cat <<EOF > ~/.config/nvim/after/plugin/nvim-tree.rc.lua
  require("nvim-tree").setup({
    actions = {
      open_file = {
        quit_on_open = true,
      },
    }
  }) 
EOF