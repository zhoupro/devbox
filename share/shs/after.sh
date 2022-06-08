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


cat <<'EOF' > ~/.config/nvim/after/plugin/defx.rc.vim
"defx    
  augroup vimrc_defx    
    autocmd!    
    autocmd FileType defx call s:defx_my_settings()    "Defx_mappings    
  autocmd VimEnter * call s:setup_defx()    
  augroup END

  function! s:defx_my_settings() abort
          " Define mappings
          nnoremap <silent><buffer><expr> <CR>
          \ defx#do_action('open')
          nnoremap <silent><buffer><expr> c
          \ defx#do_action('copy')
          nnoremap <silent><buffer><expr> m
          \ defx#do_action('move')
          nnoremap <silent><buffer><expr> p
          \ defx#do_action('paste')
          nnoremap <silent><buffer><expr> l
          \ defx#do_action('open')
          nnoremap <silent><buffer><expr> E
          \ defx#do_action('open', 'vsplit')
          nnoremap <silent><buffer><expr> P
          \ defx#do_action('preview')
          nnoremap <silent><buffer><expr> o
          \ defx#do_action('open_tree', 'toggle')
          nnoremap <silent><buffer><expr> K
          \ defx#do_action('new_directory')
          nnoremap <silent><buffer><expr> N
          \ defx#do_action('new_file')
          nnoremap <silent><buffer><expr> M
          \ defx#do_action('new_multiple_files')
          nnoremap <silent><buffer><expr> C
          \ defx#do_action('toggle_columns',
          \                'mark:indent:icon:filename:type:size:time')
          nnoremap <silent><buffer><expr> S
          \ defx#do_action('toggle_sort', 'time')
          nnoremap <silent><buffer><expr> d
          \ defx#do_action('remove')
          nnoremap <silent><buffer><expr> r
          \ defx#do_action('rename')
          nnoremap <silent><buffer><expr> !
          \ defx#do_action('execute_command')
          nnoremap <silent><buffer><expr> x
          \ defx#do_action('execute_system')
          nnoremap <silent><buffer><expr> yy
          \ defx#do_action('yank_path')
          nnoremap <silent><buffer><expr> .
          \ defx#do_action('toggle_ignored_files')
          nnoremap <silent><buffer><expr> ;
          \ defx#do_action('repeat')
	  nnoremap <silent><buffer><expr> h
          \ defx#do_action('cd', ['..'])
          nnoremap <silent><buffer><expr> ~
          \ defx#do_action('cd')
          nnoremap <silent><buffer><expr> q
          \ defx#do_action('quit')
          nnoremap <silent><buffer><expr> <Space>
          \ defx#do_action('toggle_select') . ''
          nnoremap <silent><buffer><expr> *
          \ defx#do_action('toggle_select_all')
          nnoremap <silent><buffer><expr> j
          \ line('.') == line('$') ? 'gg' : 'j'
          nnoremap <silent><buffer><expr> k
          \ line('.') == 1 ? 'G' : 'k'
          nnoremap <silent><buffer><expr> <C-l>
          \ defx#do_action('redraw')
          nnoremap <silent><buffer><expr> <C-g>
          \ defx#do_action('print')
          nnoremap <silent><buffer><expr> cd
          \ defx#do_action('change_vim_cwd')
        endfunction

  fu! s:isdir(dir) abort    
      return !empty(a:dir) && (isdirectory(a:dir) ||
            \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))
  endfu

 function! s:setup_defx() abort
       call defx#custom#option('_', {
            \ 'columns': s:default_columns,
            \ 'show_ignored_files': 0,
            \ 'buffer_name': '',
            \ 'toggle': 1,
            \ 'resume': 1,
            \ })
  
       call defx#custom#column('filename', {
            \ 'min_width': 80,
            \ 'max_width': 80,
            \ })
       call s:defx_open()
      endfunction
  
      function! s:defx_open(...) abort
         sil! au! FileExplorer *
         if s:isdir(expand('%')) | bd | exe 'Defx' | endif
      endfunction
      let s:default_columns = 'indent:git:icons:filename'
augroup defx
    au!
    au VimEnter * sil! au! FileExplorer *
    au BufEnter * if s:isdir(expand('%')) | bd | exe 'Defx' | endif
augroup END
EOF