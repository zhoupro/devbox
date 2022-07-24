-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself

  use 'wbthomason/packer.nvim'
  -- plugAddPoint

  -- plugEndPoint
  use { 'nvim-treesitter/nvim-treesitter' }
  --use {'nvim-treesitter/nvim-treesitter-textobjects'} 
  use {'akinsho/toggleterm.nvim'}
  use {'honza/vim-snippets'}
  use {'morhetz/gruvbox'}
  use {'tpope/vim-commentary'}
  --use {'neoclide/coc.nvim', branch = 'release'}
  use 'williamboman/nvim-lsp-installer'
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use  'ray-x/lsp_signature.nvim'

  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  use {'junegunn/fzf'}
  use {'junegunn/fzf.vim'}
  use {'puremourning/vimspector'}
  use {'majutsushi/tagbar'}
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

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

  use {'vim-test/vim-test'}
  use {'ferrine/md-img-paste.vim'}
  use {'dhruvasagar/vim-table-mode'}
  use {'godlygeek/tabular'}
  use {'plasticboy/vim-markdown'}
  use {'MattesGroeger/vim-bookmarks'}

end)
