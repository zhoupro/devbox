-- Only required if you have packer configured as `opt`
vim.cmd [[ packadd packer.nvim ]]

packer = require("packer")
packer.init({
    git = {
        clone_timeout = 300, -- 5 mins
    },
    max_jobs = 60,
     profile = {
        enable = true,
    },
})


 return require('packer').startup(function(use)
  use({ "zhoupro/leetcode.vim", run = "pip3 install -r requirements.txt" })
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
  use {
    'AckslD/messages.nvim',
    config = 'require("messages").setup()',
  }
    use {
     'zhoupro/own_neovim_commands',
     config = 'require("own_neovim_commands").setup()',
   }
  -- Packer can manage itself
  use 'zhoupro/vim-dadbod'
  use 'mattn/emmet-vim'
  use 'AndrewRadev/tagalong.vim'
  use 'wbthomason/packer.nvim'
  use 'solarnz/thrift.vim'
  -- plugAddPoint
  use {'MunifTanjim/nui.nvim'}
  use 'aklt/plantuml-syntax'
  use {'godlygeek/tabular'}
  use 'preservim/vim-markdown'
  use 'trmckay/based.nvim'

  -- plugEndPoint
  use { 'nvim-treesitter/nvim-treesitter' }
  --use {'nvim-treesitter/nvim-treesitter-textobjects'} 
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
  require("toggleterm").setup()
  end}

  use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}
  use {'ThePrimeagen/harpoon', requires = 'nvim-lua/plenary.nvim'}
  -- use {'morhetz/gruvbox'}
  use {'folke/tokyonight.nvim'}
  use {'tpope/vim-commentary'}
  --use {'neoclide/coc.nvim', branch = 'release'}
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use  {'hrsh7th/cmp-vsnip', requires='hrsh7th/nvim-cmp'}
  use  'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use  'rafamadriz/friendly-snippets'

  use 'ray-x/lsp_signature.nvim'
  use 'jbyuki/one-small-step-for-vimkind'
  use 'mfussenegger/nvim-dap'
  use {'zhoupro/lsp_calltree', requires='MunifTanjim/nui.nvim'}
  use 'linty-org/key-menu.nvim'
  use 'RishabhRD/popfix'
  use 'RishabhRD/nvim-cheat.sh'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }


  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }


 use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end })

  use { 'kyazdani42/nvim-web-devicons' }

  use {'junegunn/fzf'}
  use {'junegunn/fzf.vim'}
  use {'puremourning/vimspector'}
  use {'majutsushi/tagbar'}
  use {'nvim-lualine/lualine.nvim'}
  use 'WhoIsSethDaniel/lualine-lsp-progress.nvim'

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    }
  }

  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {'tpope/vim-fugitive'}
  use {'airblade/vim-gitgutter'}

  use {'wellle/targets.vim'}
  use {'jiangmiao/auto-pairs'}
  use {'tpope/vim-abolish'}
  use {'tpope/vim-surround'}
  use {'tpope/vim-repeat'}
  use "folke/neodev.nvim"
  use {'zhoupro/md-image-paste'}
  use {'dhruvasagar/vim-table-mode'}
  use {'MattesGroeger/vim-bookmarks'}
  use {'rlue/vim-barbaric'}
  use 'voldikss/vim-floaterm'
  use 'ggandor/leap.nvim'
  use 'editorconfig/editorconfig-vim'
  use 'preservim/vim-pencil'
  use 'junegunn/limelight.vim'
  use 'junegunn/goyo.vim'

end)
