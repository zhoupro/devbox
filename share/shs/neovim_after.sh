#!/bin/bash

cat <<EOF > ~/.config/nvim/after/plugin/nvim-treesitter.rc.lua
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "go","lua","vim", "java" },
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

cat <<EOF > ~/.config/nvim/after/plugin/neo-tree.rc.lua
require("symbols-outline").setup()

local harpoon_func = function(config, node, state)
  local Marked = require("harpoon.mark")
  local path = node:get_id()
  local succuss, index = pcall(Marked.get_index_of, path)
  if succuss and index and index > 0 then
    return {
      text = "+", -- <-- Add your favorite harpoon like arrow here
      highlight = config.highlight or "NeoTreeDirectoryIcon",
    }
  else
    return {}
  end
end


  require("neo-tree").setup({
    window = {
        position = "right",
        auto_expand_width = true, 
    },
    enable_diagnostics = false,
    enable_git_status = false,
    event_handlers = {
        {
            event = "file_opened",
            handler = function(file_path)
                require("neo-tree").close("filesystem")
                require("neo-tree.command").execute({action="show", source="buffers",reveal=true })
                vim.cmd("wincmd h")
                vim.api.nvim_set_keymap('n', '11', ':lua print(11)<CR>', {noremap = true})
            end
        },
        {
            event = "neo_tree_window_after_close",
            handler = function(args)
                vim.api.nvim_set_keymap('n', '11', ':lua print(11)<CR>', {noremap = true})
                vim.api.nvim_del_keymap('n', '11')
            end
        },

    },
    renderers = {
        file = {
          { "indent" },
          { "icon" },
          {
            "container",
            content = {
              { "bufnr", zindex = 10 },
              {
                "name",
                zindex = 10
              },
              { "clipboard", zindex = 10 },
              { "modified", zindex = 20, align = "right" },
              { "diagnostics",  zindex = 20, align = "right" },
              { "git_status", zindex = 20, align = "right" },
            },
          },
        },
    },
    buffers = {
    -- filesystem = {
          components = {
            harpoon_index =  harpoon_func
         },
          renderers = {
           file = {
             { "bufnr", zindex = 10 },
             {"icon"},
             {"harpoon_index"},
             {"name", use_git_status_colors = true},
             {"diagnostics"},
             {"git_status", highlight = "NeoTreeDimText"},
           }
          }
        },
    filesystem = {
          components = {
            harpoon_index = harpoon_func
          },
          renderers = {
           file = {
             {"icon"},
             {"harpoon_index"},
             {"name", use_git_status_colors = true},
             {"diagnostics"},
             {"git_status", highlight = "NeoTreeDimText"},
           }
          }
        },

  })

  vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
    end
  end
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
        window = {
              completion = {
                col_offset = 12,
              }
       },
      },
  },
}


-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'gopls', 'pyright','clangd','phpactor', 'bashls','awk_ls','html','volar','tsserver' }
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
local dap, dapui = require("dap"), require("dapui") 
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


local dapuicfg = {
    layouts = { {
        elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
        position = "bottom",
        size = 3
      } },
  }


dapui.setup(dapuicfg)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
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

local toggle_file = function ()
    require("harpoon.mark").toggle_file()
    require("neo-tree").close("filesystem")
    require("neo-tree.command").execute({action="show", source="buffers",reveal=true })
end
vim.keymap.set('n', 'tt',toggle_file )
vim.keymap.set('n', 'ta',require("harpoon.ui").toggle_quick_menu)

EOF




cat <<EOF > ~/.config/nvim/after/plugin/leap.lua
require("leap").add_default_mappings()
vim.keymap.del({'x','o'},'x')
vim.keymap.del({'x','o'},'X')
EOF

cat <<EOF > ~/.config/nvim/after/plugin/colorschem.rc.vim
silent! colorscheme tokyonight
highlight Normal ctermbg=None
EOF

cat <<EOF > ~/.config/nvim/after/plugin/mdpaste.rc.vim
    autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
    " there are some defaults for image directory and image name, you can change them
    " let g:mdip_imgdir = 'img'
    " let g:mdip_imgname = 'image'"
EOF


cat <<EOF > ~/.config/nvim/after/plugin/outline.rc.lua
require("symbols-outline").setup()
EOF

cat <<EOF > ~/.config/nvim/after/plugin/neogen.rc.lua
require('neogen').setup({ snippet_engine = "vsnip" })
EOF

