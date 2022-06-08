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
  use {'neoclide/coc.nvim', branch = 'release'}
  use {'Shougo/defx.nvim'}
  use {'kristijanhusak/defx-icons'}
  use {'kristijanhusak/defx-git'}
  use {'junegunn/fzf'}
  use {'junegunn/fzf.vim'}
  use {'puremourning/vimspector'}
  use {'majutsushi/tagbar'}
  use {'vim-airline/vim-airline'}
  use {'vim-airline/vim-airline-themes'}
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
