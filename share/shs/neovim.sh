#读取参数
# install neovim

if [ ! -f /usr/local/bin/vim ];then
    if [ ! -f nvim.appimage ];then
        pxy wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    fi
    sudo chmod u+x nvim.appimage && sudo ./nvim.appimage --appimage-extract
    sudo mkdir -p /opt/soft/nvim
    sudo mv squashfs-root/* /opt/soft/nvim/
    sudo rm -f /usr/local/bin/vim
    sudo ln -s  /opt/soft/nvim/usr/bin/nvim /usr/local/bin/vim
    sudo rm -f /usr/local/bin/nvim
    sudo ln -s  /opt/soft/nvim/usr/bin/nvim /usr/local/bin/nvim
    rm -rf nvim.appimage
fi

if [ ! "$(pip3 list | grep neovim)" ];then
    pip3 install neovim --upgrade
fi

#-------------------------------------------------------------------------------
# install vim-plug
#-------------------------------------------------------------------------------
if  [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ] ; then
    pxy curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

rm -f ~/.config/nvim/init.vim

cat <<EOF > ~/.config/nvim/init.vim

runtime ./settings.vim
runtime ./plug.vim
runtime ./maps.vim
runtime ./func.vim
runtime ./cmd.vim

EOF

cat <<EOF > ~/.config/nvim/settings.vim
    let mapleader=","
    set noswapfile
    set hlsearch
    set incsearch
    set nu
    set list
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set foldmethod=manual
    highlight Normal ctermbg=None


   let g:vimspector_enable_mappings = 'HUMAN'
   let test#strategy='neovim'
EOF

cat <<EOF > ~/.config/nvim/maps.vim
   inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
   nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
   map <leader>n :Defx<CR>
   map <leader>m :TagbarOpenAutoClose<CR>
   autocmd VimEnter * noremap  <leader>t  :call RunProgram()<CR>
   nnoremap <Leader>f :Files<CR>
   nnoremap <leader>y :call system('nc -q 1  localhost 8377', @0)<CR>
   " Terminal mode:
    tnoremap <leader>h <c-\><c-n><c-w>h
    tnoremap <leader>j <c-\><c-n><c-w>j
    tnoremap <leader>k <c-\><c-n><c-w>k
    tnoremap <leader>l <c-\><c-n><c-w>l
    " Insert mode:
    inoremap <leader>h <Esc><c-w>h
    inoremap <leader>j <Esc><c-w>j
    inoremap <leader>k <Esc><c-w>k
    inoremap <leader>l <Esc><c-w>l
    " Visual mode:
    vnoremap <leader>h <Esc><c-w>h
    vnoremap <leader>j <Esc><c-w>j
    vnoremap <leader>k <Esc><c-w>k
    vnoremap <leader>l <Esc><c-w>l
    " Normal mode:
    nnoremap <leader>h <c-w>h
    nnoremap <leader>j <c-w>j
    nnoremap <leader>k <c-w>k
    nnoremap <leader>l <c-w>l
    nnoremap <silent> <Leader>a :Rg <C-R><C-W><CR>
    noremap \ ,
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
    map  <leader>ef  :call ExtraFunc()<CR>
EOF


cat <<EOF > ~/.config/nvim/plug.vim
call plug#begin('~/.local/share/nvim/plugged')
   Plug 'honza/vim-snippets'
   Plug 'fvictorio/vim-extract-variable'
   Plug 'morhetz/gruvbox'
   Plug 'tpope/vim-commentary'
   "complete
   Plug 'neoclide/coc.nvim', {'branch': 'release'}
   Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
   Plug 'kristijanhusak/defx-icons'
   Plug 'kristijanhusak/defx-git'
    " explore
   Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
   Plug 'junegunn/fzf.vim'
   Plug 'puremourning/vimspector'
   Plug 'majutsushi/tagbar'
   "outline
   Plug 'vim-airline/vim-airline'
   Plug 'vim-airline/vim-airline-themes'
   Plug 'vim-scripts/ctags.vim'
   "git
   Plug 'tpope/vim-fugitive'
   Plug 'airblade/vim-gitgutter'

   Plug 'wellle/targets.vim'
   Plug 'jiangmiao/auto-pairs'
   Plug 'tpope/vim-abolish'
   Plug 'tpope/vim-surround'
   Plug 'tpope/vim-repeat'

   Plug 'vim-test/vim-test'
   Plug 'nvim-treesitter/nvim-treesitter', {'branch' : '0.5-compat'}
   Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch' : '0.5-compat'}
   Plug 'ferrine/md-img-paste.vim'
   
call plug#end()
EOF


cat <<'EOF' > ~/.config/nvim/func.vim
func! RunProgram()    
      exec "w"    
      if &filetype == 'c'    
         exec "!gcc % -o %<"    
         exec "! ./%<"    
      elseif &filetype == 'cpp'    
         exec "!g++ % -o %<"    
         exec "! ./%<"    
      elseif &filetype == 'sh'    
         exec "!bash %"    
      elseif &filetype == 'go'    
         exec "!go run %"    
      elseif &filetype == 'python'    
         exec "!python %"    
      elseif &filetype == 'php'    
         exec "!php %"    
      elseif &filetype == 'lua'    
         exec "!lua %"    
      elseif &filetype == 'java'    
         exec "!javac %"    
         exec "!java -cp %:p:h %:t:r"    
      endif    
  endfunc    
 
fu! s:isdir(dir) abort
      return !empty(a:dir) && (isdirectory(a:dir) ||
      \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))
  endfu

fun! Mytest()
      execute "normal yaf"
      let funcName = matchstr(@*, '^func\s*\(([^)]\+)\)\=\s*\zs\w\+\ze(')
      let tmplDir = ''
      let file = expand('%')
  
      if stridx(funcName, "Test") >= 0
         let normal_file = substitute(file, '_test\.go', '\.go', "")
         let normalFuncName = substitute(funcName, 'Test_', '', "")
         execute "edit " . normal_file
         execute "normal /" . normalFuncName ."\<CR>"
      else
         let test_file = substitute(file, '\.go', '_test\.go', "")
         let out = system('gotests -w -only ' . shellescape(funcName) . ' ' . tmplDir . ' ' . shellescape(file))
         execute "edit " . test_file
         execute "normal /Test_" . funcName ."\<CR>"
      endif
  endfun

fun! Toggle_qmode()
     if !exists('b:qmode')
        let b:qmode = 1
         nmap b <Plug>VimspectorToggleBreakpoint
         nmap bc <Plug>VimspectorToggleConditionalBreakpoint
         nmap bf <Plug>VimspectorAddFunctionBreakpoint
         nmap c <Plug>VimspectorContinue
         nmap n <Plug>VimspectorStepOver
         nmap si <Plug>VimspectorStepInto
         nmap so <Plug>VimspectorStepOut
         nmap e <Plug>VimspectorBalloonEval
         nmap t :call Mytest()<CR>
        echo "Using smart quotes"
     else
        unlet b:qmode
         unmap b
         unmap bc
         unmap bf
         unmap c
         unmap n
         unmap si
         unmap so
         unmap t
        echo "Using regular quotes"
     endif
      AirlineToggle
  endfun

function! Get_visual_content()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    return lines
endfunction




function! Get_visual_start_end_byte()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let start_byte = eval(line2byte(line_start)+column_start)
    let end_byte = eval(line2byte(line_end)+column_end)
    let file = expand('%')
    let cmd_str = 'guru freevars ' . shellescape(file).':#'.start_byte.',#'.end_byte
    let cmd_str = cmd_str . '| grep -v "identifiers" | awk -F ":" '. "'{print \$3}'"
    let cmd_str = cmd_str . "|sed -e ':a' -e 'N' -e '\$!ba' -e 's/\\n/, /g'"
    let cmd_str = cmd_str . "|sed 's#var##g'"
    let out = system(cmd_str)[:-2]
    return out
endfunction

function! Get_visual_parms()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let start_byte = eval(line2byte(line_start)+column_start)
    let end_byte = eval(line2byte(line_end)+column_end)
    let file = expand('%')
    let cmd_str = 'guru freevars ' . shellescape(file).':#'.start_byte.',#'.end_byte
    let cmd_str = cmd_str . '| grep -v "identifiers" | awk -F ":" '. "'{print \$3}'"
    let cmd_str = cmd_str . '| awk  '. "'{print \$2}'"
    let cmd_str = cmd_str . "|sed -e ':a' -e 'N' -e '\$!ba' -e 's/\\n/, /g'"
    let out = system(cmd_str)[:-2]
    return out
endfunction



function! Get_func_end()
    exec "normal vaf\<esc>"
    " Why is tchis not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    return line_end
endfunction


fun! ExtraFunc()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = Get_visual_content()
    let params_str = Get_visual_start_end_byte()
    let params_str_var = Get_visual_parms()

    let lines =  ["func MYFUNC(".params_str.'){'] + lines
    let lines = lines + ["}"]
    let func_end_line = Get_func_end()
    call append(func_end_line, lines)
    let func_str = "MYFUNC(". params_str_var.')'

    execute line_start."," line_end."d"
    call append(line_start-1, func_str)
    execute "w"

    try
      " Jump to the word
      execute ":ijump MYFUNC" 
    catch /E387:/
      " we're already on that line
    endtry

    execute "call  CocActionAsync('rename')"
endfun

EOF

cat <<EOF > ~/.config/nvim/cmd.vim
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --hidden --ignore-case --ignore-file ~/.fzf_ignore --no-heading --color=always '.<q-args>, 1,
    \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
    \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
    \   <bang>0)
command Gg call system('echo '.expand("%"). '>> .git/info/exclude')
command! ToggleDebug call Toggle_qmode()


EOF


mkdir -p ~/.config/nvim/after/plugin



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
          \ defx#do_action('toggle_select') . 'j'
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
EOF


cat <<EOF > ~/.config/nvim/coc-settings.json

{
  "suggest.triggerAfterInsertEnter": true,
  "suggest.noselect": false,
  "python.linting.enabled": false,
  "python.jediEnabled": false,
  "suggest.timeout": 3500,
  "suggest.minTriggerInputLength": 2,
  "suggest.echodocSupport": true,
  "Lua.runtime.path":["/usr/local/share/lua/5.3/?.lua","/usr/local/share/lua/5.3/?/init.lua","/usr/local/lib/lua/5.3/?.lua","/usr/local/lib/lua/5.3/?/init.lua","/usr/share/lua/5.3/?.lua","/usr/share/lua/5.3/?/init.lua","./?.lua","./?/init.lua","/root/.config/awesome/?.lua","/root/.config/awesome/?/init.lua","/etc/xdg/awesome/?.lua","/etc/xdg/awesome/?/init.lua","/usr/share/awesome/lib/?.lua","/usr/share/awesome/lib/?/init.lua"],
  "Lua.workspace.library":["/usr/share/awesome/lib"],
  "Lua.diagnostics.enable":false,
  "suggest.enablePreview": false,
  "go.goplsOptions": {
      "analyses": { "unsafeptr": false }
  }
}

EOF



pxy nvim +'PlugInstall --sync' +qall
# install some lsp
nvim "+CocInstall -sync coc-vimlsp" +qall
nvim "+CocInstall -sync coc-python" +qall
nvim "+CocInstall -sync coc-html coc-css coc-tsserver coc-emmet" +qall

if ! which bash-language-server > /dev/null; then
    sudo npm i -g bash-language-server --unsafe-perm
fi

nvim "+CocInstall -sync coc-sh" +qall
nvim "+CocInstall -sync coc-snippets" +qall
nvim "+CocInstall -sync coc-clangd" +qall



function go_ins(){
    ! (grep -F 'sebdah/vim-delve' /home/vagrant/.config/nvim/plug.vim &>/dev/null ) && \
    sed -i "/plug#begin/aPlug 'fatih/vim-go'" /home/vagrant/.config/nvim/plug.vim
    export PATH=$PATH:/usr/local/go/bin:/home/vagrant/go/bin
    pxy nvim +'GoInstallBinaries' +qall
    pxy go get -u github.com/cweill/gotests/...
    pxy nvim -E -c 'CocCommand go.install.tools' -c qall
    nvim +'CocInstall -sync coc-go' +qall
    ! ( grep -F "leetcode_solution_filetype" /home/vagrant/.config/nvim/init.vim ) && \
    cat >> /home/vagrant/.config/nvim/init.vim <<END
    let g:leetcode_solution_filetype='golang'
END
}
go_ins


cat <<EOF > ~/.config/nvim/after/plugin/colorschem.rc.vim
colorscheme gruvbox
set background=dark
EOF

cat <<EOF > ~/.config/nvim/after/plugin/mdpaste.rc.vim
    autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
    " there are some defaults for image directory and image name, you can change them
    " let g:mdip_imgdir = 'img'
    " let g:mdip_imgname = 'image'"
EOF



cat <<EOF > ~/.config/nvim/after/plugin/nvim-treesitter.rc.lua
require'nvim-treesitter.configs'.setup {
    highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "toml",
    "fish",
    "python",
    "go",
    "json",
    "yaml",
    "html",
    "scss"
  },
    textobjects = {
      select = {
       enable = true,
  
       -- Automatically jump forward to textobj, similar to targets.vim-
       lookahead = true,
  
       keymaps = {
         -- You can use the capture groups defined in textobjects.scm
         ["af"] = "@function.outer",
         ["if"] = "@function.inner",
         ["ac"] = "@class.outer",
         ["ic"] = "@class.inner",
  
         -- Or you can define your own textobjects like this
         ["iF"] = {
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function",
         },
       },
      },
    },
  }

EOF


