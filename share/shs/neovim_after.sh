#!/bin/bash

cat <<EOF > ~/.config/nvim/after/plugin/nvim-treesitter.rc.lua
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "go","lua" },
    highlight = {
    enable = true,
    disable = {"json","markdown","vim"},
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
local function getEnWords()
   if vim.bo.filetype ~= "markdown" then
      return ""
   end
  local fileName = vim.fn.expand('%')
  local res = os.capture("[ -e "..fileName.." ] && cat " .. fileName .. " | sed 's/!\\\\[.*]\\\\(.*\\\\)//g' | sed 's/[[:punct:]]//g' | tr -cd '\\\\11\\\\12\\\\15\\\\40-\\\\176' | wc -w")
  return res .. " words"
end

local function getCnWords()
  if vim.bo.filetype ~= "markdown" then
      return ""
   end
  local fileName = vim.fn.expand('%')
  local res = os.capture("[ -e "..fileName.." ] && cat " .. fileName .. " | sed 's/!\\\\[.*]\\\\(.*\\\\)//g' | grep -o -P '[\\\\p{Han}]'| tr -d '\\n' | wc -m")
  return res .. " zi"
end


require('lualine').setup({
  options = {
    disabled_filetypes = {'NvimTree', 'VimspectorPrompt'}
  },
  sections = {
    lualine_c = {'filename', {getEnWords}, {getCnWords},'lsp_progress'},
  }
})
EOF

cat <<EOF > ~/.config/nvim/after/plugin/nvim-tree.rc.lua
vim.api.nvim_create_autocmd('BufEnter', {
    command = "if winnr('$') == 1 && bufname() == ''  | quit | endif",
    nested = true,
})
  require("nvim-tree").setup({
    actions = {
      open_file = {
        quit_on_open = true,
      },
  
    },
    view = {
      adaptive_size = true,
      centralize_selection = false,
      width = 30,
      hide_root_folder = false,
      side = "left",
      preserve_window_proportions = false,
      number = false,
      relativenumber = false,
      signcolumn = "yes",
      mappings = {
        custom_only = false,
        list = {
          -- user mappings go here
        },
      },
      float = {
        enable = false,
        open_win_config = {
          relative = "editor",
          border = "rounded",
          width = 100,
          height = 30,
          row = 1,
          col = 1,
        },
      },
    },
  }) 
EOF

cat <<EOF > ~/.config/nvim/after/plugin/nvim-lspconfig.lua


require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

vim.o.timeoutlen=1000
require("mason").setup {
}
require("mason-lspconfig").setup {
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
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
capabilities.textDocument.completion.completionItem.snippetSupport = true


lspconfig.lua_ls.setup {
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
          enable= false,
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
        completion = {
           callSnippet = "Replace"
        },
      },
  },
}


-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'gopls', 'pyright','clangd','phpactor', 'bashls','awk_ls','html','sqls','volar','tsserver' }
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
    { name = 'path' },
     { name = 'buffer' },
  },
}

vim.cmd([[
  autocmd FileType sql lua require('cmp').setup.buffer{
    \sources = {{name='nvim_lsp'}},
  \}
]])
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
require("ufo").setup()
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


cat <<EOF > ~/.config/nvim/after/plugin/base.lua
local based = require("based")

based.setup({
    highlight = "MyHighlightGroup"
})
vim.keymap.set('n', '<C-b>',  based.convert)

EOF



cat <<EOF > ~/.config/nvim/after/plugin/leap.lua
require("leap").add_default_mappings()
vim.keymap.del({'x','o'},'x')
vim.keymap.del({'x','o'},'X')
EOF
