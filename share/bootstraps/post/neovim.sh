#!/bin/bash
source /vagrant_data/shs/utils.sh

#读取参数# install neovim
if [ ! -f /usr/local/bin/vim ];then
      proxy && \
      axel -n 20 -o nvim.appimage 'https://github.com/neovim/neovim/releases/download/stable/nvim.appimage'
      noproxy && \
      mv ./nvim.appimage /usr/local/bin/nvim    && \
      ln -s /usr/local/bin/nvim /usr/local/bin/vim && \
      chmod 777 /usr/local/bin/nvim 
fi

if [ ! "$(pip3 list | grep neovim)" ];then
    pip3 install neovim --upgrade
fi

 cp /vagrant_data/conf/rootCA.crt /usr/local/share/ca-certificates/
 update-ca-certificates
#-------------------------------------------------------------------------------
# install dein 
#-------------------------------------------------------------------------------
#if  [ ! -f ~/.vim/dein/repos/github.com/Shougo/dein.vim ] ; then
#    cp /vagrant_data/shs/install.sh  . && \
#    chmod u+x install.sh && ./install.sh ~/.vim/dein
#fi
#-------------------------------------------------------------------------------
# install vim-plug
#-------------------------------------------------------------------------------
if  [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ] ; then
    curl -k -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs `getDownloadUrl 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'` 
    #mkdir -p ~/.local/share/nvim/site/autoload 
    #cp /vagrant_data/conf/plug.vim  ~/.local/share/nvim/site/autoload/
fi

mkdir -p ~/.config/nvim
rm -f ~/.config/nvim/init.vim


cat <<EOF > ~/.config/nvim/init.vim

runtime ./settings.vim
runtime ./plug.vim
runtime ./maps.vim
runtime ./func.vim
runtime ./cmd.vim
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
   "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
   Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
   Plug 'junegunn/fzf.vim'
   Plug 'puremourning/vimspector'
   Plug 'majutsushi/tagbar'
   "outline
   Plug 'vim-airline/vim-airline'
   Plug 'vim-airline/vim-airline-themes'
   "git
   Plug 'tpope/vim-fugitive'
   Plug 'airblade/vim-gitgutter'

   Plug 'wellle/targets.vim'
   Plug 'jiangmiao/auto-pairs'
   Plug 'tpope/vim-abolish'
   Plug 'tpope/vim-surround'
   Plug 'tpope/vim-repeat'

   Plug 'vim-test/vim-test'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
   Plug 'ferrine/md-img-paste.vim'
   Plug 'dhruvasagar/vim-table-mode'
   Plug 'godlygeek/tabular'
   Plug 'plasticboy/vim-markdown'
   Plug 'MattesGroeger/vim-bookmarks'
call plug#end()
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
    autocmd Filetype json let g:indentLine_enabled = 0
    let g:vimspector_enable_mappings = 'HUMAN'
    let test#strategy='neovim'
    let g:airline_section_z = 'happy'
    set cmdheight=2

    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_auto_save = 1
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
    nmap <silent> gc :CocCommand  document.showIncomingCalls<CR>
    autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
    map  <leader>ef  :call ExtraFunc()<CR>
    map  ma  :call Mybks()<CR>
    map  <leader>ef  :call ExtraFunc()<CR>

    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    nmap <leader>1 <Plug>AirlineSelectTab1
    nmap <leader>2 <Plug>AirlineSelectTab2
    nmap <leader>3 <Plug>AirlineSelectTab3
    nmap <leader>4 <Plug>AirlineSelectTab4
    nmap <leader>5 <Plug>AirlineSelectTab5
    nmap <leader>6 <Plug>AirlineSelectTab6
    nmap <leader>7 <Plug>AirlineSelectTab7
    nmap <leader>8 <Plug>AirlineSelectTab8
    nmap <leader>9 <Plug>AirlineSelectTab9
    nmap <leader>0 <Plug>AirlineSelectTab0
    nmap <leader>- <Plug>AirlineSelectPrevTab
    nmap <leader>+ <Plug>AirlineSelectNextTab
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

fun! GenTest()
    execute "normal yaf"
    " func line
    let funcName = matchstr(@*, '^func\s*\(([^)]\+)\)\=\s*\zs\w\+\ze(')
    
    " func name
    "let funcName = matchstr(@*, '\vfunc ?\(.*\) ?\zs\w+\ze\(')

    " type name
    let typeName = matchstr(@*, '\v^func ?\([a-z]+ \zs[a-z]+\ze\)')

    let testPrefix="Test_"
    if len(typeName) > 0
      let testPrefix="Test_".typeName."_"
    endif


    let tmplDir = ''
    let file = expand('%')
    
    if stridx(file, "_test") >= 0
       let normal_file = substitute(file, '_test\.go', '\.go', "")
       let splitParts = split(funcName, '_')
       execute "edit " . normal_file
       execute "normal /" . splitParts[-1] ."\<CR>"
    else
       let test_file = substitute(file, '\.go', '_test\.go', "")
       let out = system('gotests -w -only "(?i)^(' . typeName . funcName . ')" ' . tmplDir . ' ' . shellescape(file))
       execute "edit " . test_file
       execute "normal /". testPrefix . funcName ."\<CR>"
    endif
endfun

fun! VimspectorConfigGen()    
      let cur_line = line(".")    
      execute "normal yaf"    
      let funcName = matchstr(@*, '^func\s*\(([^)]\+)\)\=\s*\zs\w\+\ze(')    
      execute cur_line    
      call system("bash /vagrant_data/shs/vimspector_config_gen.sh " . funcName)    
endfun



fun! Toggle_qmode()
    if !exists('b:qmode')
        call VimspectorConfigGen()
        let b:qmode = 1
         nmap b <Plug>VimspectorToggleBreakpoint
         nmap bc <Plug>VimspectorToggleConditionalBreakpoint
         nmap bf <Plug>VimspectorAddFunctionBreakpoint
         nmap c <Plug>VimspectorContinue
         nmap n <Plug>VimspectorStepOver
         nmap si <Plug>VimspectorStepInto
         nmap so <Plug>VimspectorStepOut
         nmap e <Plug>VimspectorBalloonEval
         nmap t :call GenTest()<CR>
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
     endif
     "AirlineToggle
endfun


fun! Toggle_gomode()
    if !exists('b:gomode')
        let b:gomode = 1
        nmap t :call GenTest()<CR>
     else
        unlet b:gomode
        unmap t
     endif
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

function! Mybookmarks() abort
  return filter(map(bm#location_list(), { _, b -> s:bookmarks_format_line(b) }), { _, b -> b !=# '' })
endfunction

function! s:bookmarks_format_line(line) abort
  let line = split(a:line, ':')
  let filename = fnamemodify(line[0], ':.')
  if !filereadable(filename)
    return ''
  endif

  let line_number = line[1]
  let text = line[2]

  if text ==# 'Annotation'
    let comment = line[3]
  else
    let text = join(line[2:], ':')
  endif

  return line_number ." ".  filename

endfunction

    "\ call fzf#vim#marks(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir MyFile
    \ call fzf#vim#marks(<bang>0)

function! MySink(line)
  let lineinfo=split(a:line)
  exec "e ".lineinfo[1]
  exec lineinfo[0]
  exec "normal zz"
endfunction

function! Mybks()
    let mmm=Mybookmarks()
    call fzf#run(fzf#wrap({'source': mmm,'options': ['--preview', 'start=$(echo {1}-4|bc) && if [ $start -lt 0 ];then start=0;fi;end=$(echo {1}+12|bc)  &&  batcat    --color=always --style=numbers -H {1} --line-range=$start:$end {2}'],'sink':function("MySink") }))
endfunction

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
command! ToggleTest call Toggle_gomode()

EOF

mkdir -p ~/.config/nvim/after/plugin

cat <<'EOF' > ~/.config/nvim/after/plugin/markdown.rc.vim
    let g:vim_markdown_folding_disabled = 1
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


proxy
nvim +'PlugInstall --sync' +qall  
noproxy

nvim "+CocInstall -sync coc-snippets" +qall 


function go_ins(){
    ! (grep -F 'sebdah/vim-delve' ~/.config/nvim/plug.vim &>/dev/null ) && \
    sed -i "/plug#begin/aPlug 'fatih/vim-go'" ~/.config/nvim/plug.vim
    export PATH=$PATH:/usr/local/go/bin:~/go/bin
    nvim +'GoInstallBinaries' +qall
    go get -u github.com/cweill/gotests/...
    nvim -E -c 'CocCommand go.install.tools' -c qall
    nvim +'CocInstall -sync coc-go' +qall
    ! ( grep -F "leetcode_solution_filetype" ~/.config/nvim/init.vim ) && \
    cat >> ~/.config/nvim/init.vim <<END
    let g:leetcode_solution_filetype='golang'
END
}
go_ins


function leetcode_ins(){
    ! (grep -F 'zhoupro/leetcode' ~/.config/nvim/plug.vim &>/dev/null ) && \
    pip3 install requests beautifulsoup4 && \
    sed -i "/plug#begin/aPlug 'zhoupro/leetcode.vim', { 'do': 'pip3 install -r requirements.txt' }" ~/.config/nvim/plug.vim

    ! ( grep -F "LeetCodeList" ~/.config/nvim/init.vim ) && \
cat >> ~/.config/nvim/init.vim <<END
    nnoremap <leader>ll :LeetCodeList<cr>
    nnoremap <leader>lt :LeetCodeTest<cr>
    nnoremap <leader>ls :LeetCodeSubmit<cr>
END
}

leetcode_ins

proxy
nvim +'PlugInstall --sync' +qall
noproxy


cat <<EOF > ~/.config/nvim/after/plugin/colorschem.rc.vim
silent! colorscheme gruvbox
set background=dark
highlight Normal ctermbg=None
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