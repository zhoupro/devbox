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

cat <<EOF > ~/.config/nvim/after/plugin/nvim-lspconfig.lua

require("nvim-lsp-installer").setup {
  automatic_installation = false
}

local lspconfig = require("lspconfig")


lspconfig.gopls.setup {}
lspconfig.pyright.setup {}
lspconfig.clangd.setup {}

-- Mappings.
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'ic', vim.lsp.buf.incoming_calls, bufopts)

  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end



 -- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = {'vim','describe','it'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
  },
}


-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'gopls', 'pyright','clangd','phpactor', 'bashls','awk_ls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end




local signature_config = {
  log_path = "/tmp/sig.log",
  debug = true,
  hint_enable = false,
  handler_opts = { border = "single" },
  max_width = 80,
}

require("lsp_signature").setup(signature_config)

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) 
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  },
}
EOF


cat <<EOF > ~/.config/nvim/after/plugin/nvim-dap.lua
local dap = require"dap"
dap.configurations.lua = { 
  { 
    type = 'nlua', 
    request = 'attach',
    name = "Attach to running Neovim instance",
    host = function()
      return '127.0.0.1'
    end,
    port = function()
      local val = vim.fn.input('Port: ')
      if val ~= "" then
        return tonumber(val)
      end
      return 8086
    end,
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host, port = config.port })
end

EOF


cat <<EOF > ~/.config/nvim/after/plugin/md-image-paste.lua
require('md-image-paste').setup({})
EOF

cat <<EOF > ~/.config/nvim/after/plugin/lsp-calltree.lua
require('calltree').setup({})
EOF

cat <<EOF > ~/.config/nvim/after/plugin/nvim-ufo.lua
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
EOF

cat <<EOF > ~/.config/nvim/after/plugin/harpoon.lua
vim.keymap.set('n', 'tt',require("harpoon.mark").add_file )
vim.keymap.set('n', 'ta',require("harpoon.ui").toggle_quick_menu)
EOF

cat <<EOF > ~/.config/nvim/after/plugin/key-menu.lua
vim.o.timeoutlen = 300
require 'key-menu'.set('n', '<Space>')
vim.keymap.set('n', '<Space>w', '<Cmd>w<CR>', {desc='Save'})
vim.keymap.set('n', '<Space>q', '<Cmd>q<CR>', {desc='Quit'})

local erase_all_lines = function()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
end
vim.keymap.set('n', '<Space>k', erase_all_lines, {desc='Erase all'})

vim.keymap.set('n', '<Space>gs', '<Cmd>Git status<CR>')
vim.keymap.set('n', '<Space>gc', '<Cmd>Git commit<CR>')

require 'key-menu'.set('n', '<Space>g', {desc='Git'})

vim.keymap.set('n', '<Space>g',
  function() require 'key-menu'.open_window('<Space>g') end,
  {desc='Git'})


require 'key-menu'.set('n', '<Space>s',
  {desc = 'Say something', buffer = true})
vim.keymap.set('n', '<Space>sh',
  function() print('Hello, world') end,
  {desc = '...hello!', buffer = true})
vim.keymap.set('n', '<Space>sg',
  function() print('Goodbye, world!') end,
  {desc = '...goodbye!', buffer = true})

vim.keymap.set('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>', {desc='HIDDEN'})
EOF




echo "export PATH=\$PATH:/usr/local/lib/nodejs/node/bin" >> ~/.zshrc
echo "export PATH=\$PATH:/usr/local/lib/nodejs/node/bin" >> ~/.bashrc
