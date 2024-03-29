#!/bin/bash
source /vagrant_data/shs/utils.sh

echo "install base packer"

#读取参数# install neovim
if [ ! -f /usr/local/bin/vim ];then
      proxy && \
      axel -n 20 -o nvim.appimage 'https://github.com/neovim/neovim/releases/download/stable/nvim.appimage'
      noproxy && \
      sudo sudo mv ./nvim.appimage /usr/local/bin/nvim    && \
      sudo sudo ln -s /usr/local/bin/nvim /usr/local/bin/vim && \
      sudo chmod 777 /usr/local/bin/nvim 
fi

sudo apt install -y fuse3

if [ ! "$(pip3 list | grep neovim)" ];then
    pip3 install neovim --upgrade
fi

rm -rf ~/.config/nvim
#-------------------------------------------------------------------------------
# install packer
#-------------------------------------------------------------------------------
if  [ ! -d  ~/.local/share/nvim/site/pack/packer/start/packer.nvim ] ; then
    proxy
    mkdir -p ~/.local/share/nvim/site/pack/packer/start && \
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
       ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    noproxy
fi

mkdir -p ~/.config/nvim
sudo rm -f ~/.config/nvim/init.vim
sudo rm -f ~/.config/nvim/snips
mkdir -p  ~/.config/nvim/lua && \
cp /vagrant_data/conf/nvim/plugins.lua  ~/.config/nvim/lua/plugins.lua

mkdir -p  ~/.config/nvim/snips && \
cp /vagrant_data/conf/nvim/snips/* ~/.config/nvim/snips -R


cat <<EOF > ~/.config/nvim/init.vim
  runtime ./settings.vim
  lua require('plugins')
  runtime ./maps.vim
  runtime ./func.vim
  runtime ./cmd.vim
EOF


cat <<EOF > ~/.config/nvim/settings.vim
    let mapleader=","
    set noswapfile
    set clipboard=unnamedplus
    set hlsearch
    set incsearch
    set nu
    set list
    set tabstop=4
    set shiftwidth=4
    set expandtab
    "set foldmethod=manual
    set mouse=i
    let g:vimspector_enable_mappings = 'HUMAN'
    let test#strategy='neovim'
    set cmdheight=2
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_auto_save = 1
    autocmd Filetype json let g:indentLine_enabled = 0
    set mouse+=a
    let g:go_gopls_enabled = 0


    let g:fzf_preview_window = ['up:10%:hidden','ctrl-/']
    let g:fzf_layout = {'window':{'width':0.90, 'height':0.90}}
    let g:vsnip_snippet_dir = expand('~/.config/nvim/snips')

    let g:mkdp_open_to_the_world = 1
    let g:mkdp_command_for_global = 1
    let g:mkdp_open_ip = '192.168.56.100'
    let g:mkdp_port = 8080
    function! g:Open_browser(url)
        let tmp = '!curl http://192.168.56.1:8377/openurl -d "{\"url\":\"' . a:url .  '\"}" -X POST -H "Content-Type:application/json"'
        silent exe tmp
    endfunction
    let g:mkdp_browserfunc = 'g:Open_browser'

    fu! s:isdir(dir) abort
        return !empty(a:dir) && (isdirectory(a:dir) ||
        \ (!empty(\$SYSTEMDRIVE) && isdirectory('/'.tolower(\$SYSTEMDRIVE[0]).a:dir)))
    endfu
       let g:vimspector_sign_priority = {
  \    'vimspectorBP':         103,
  \    'vimspectorBPCond':     102,
  \    'vimspectorBPLog':      102,
  \    'vimspectorBPDisabled': 101,
  \    'vimspectorPC':         999,
  \ }
   let g:pencil#conceallevel = 0
    let g:mkdp_preview_options = {
    \ 'uml': { 'server': 'http://192.168.56.100:8080'}
    \ }
EOF

cat <<EOF > ~/.config/nvim/maps.vim
   inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
   nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
   map <leader>n :NeoTreeClose<CR>:NeoTreeFocus<CR>
   map <leader>m :TagbarOpenAutoClose<CR>
   autocmd VimEnter * noremap  <leader>t  :call RunProgram()<CR>
   nnoremap <Leader>f :Files<CR>
   " nnoremap <leader>y :call CopyToTmp()<CR>
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
    "nmap <silent> gd <Plug>(coc-definition)
    "nmap <silent> gy <Plug>(coc-type-definition)
    "nmap <silent> gi <Plug>(coc-implementation)
    "nmap <silent> gr <Plug>(coc-references)
    "nmap <silent> gic :CocCommand  document.showIncomingCalls<CR>
    map  ma  :call Mybks()<CR>
    nnoremap <silent> <C-n>  <Cmd>BufferNext<CR>
    nnoremap <silent> <C-c>  <Cmd>BufferClose<CR>
    nnoremap <silent> <C-p>  <Cmd>BufferPick<CR>



imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'    : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'    : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'    : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'    : '<S-Tab>'


EOF



cat <<'EOF' > ~/.config/nvim/func.vim

fun! CopyToTmp()
   let buffer_raw = getreg('@')
   call writefile(split(buffer_raw, "\n", 1) , "/tmp/copy.txt", "b")
   call system('curl -H "Content-Type:text/plain" --data-binary @/tmp/copy.txt http://192.168.56.1:8377/setclip')
endfun

function! s:get_std_pkgs()
    function! s:go_import(pk)
        execute 'GoImport' a:pk
    endfunction
    call fzf#run(fzf#wrap({'source': 'gopkgs | sort | uniq', 'sink': function('s:go_import')}))
endfunction


function! s:get_lib_pkgs(flag)
    echom a:flag
    let gomod = system('bash /vagrant_data/shs/getpwd.sh')

    function! s:go_import(pk)
        execute 'GoImport' a:pk

        let packpostfix = system("echo ".a:pk."|awk -F '/' '{printf $NF}'")
        execute 'normal o' packpostfix
    endfunction

    function! s:go_import_lib(pk)
        let gomod = system('bash /vagrant_data/shs/getpwd.sh')
        let cmd_str = "cat ". gomod ."| grep -v '=>' | grep  '.*\..*' | grep -w ^ | grep  ".a:pk."|awk '{printf $2}'"
        let lib_version = system(cmd_str)
        let lib_dir = "~/go/pkg/mod/".a:pk.'@'.lib_version
        let source_cmd_str = "cd ".lib_dir." && go list ./... | grep -v 'downloading'|sort"
        call fzf#run(fzf#wrap({'source': source_cmd_str, 'sink': function('s:go_import')}))
    endfunction

    let cmd_str = "cat ". gomod ."| grep -v '=>' | grep  '.*\..*' | grep -w ^ | awk '{print $1}' | sort | uniq"

    if a:flag == 1
        call fzf#run(fzf#wrap({'source': cmd_str, 'sink': function('s:go_import')}))
    else
        call fzf#run(fzf#wrap({'source': cmd_str, 'sink': function('s:go_import_lib')}))
    endif

endfunction


function! s:get_workspace_pkgs(flag)
    let workspace = system('bash /vagrant_data/shs/getpwdpath.sh')
    let gomod = system('bash /vagrant_data/shs/getpwd.sh')
    let gomoduleprefix = system("cat ".gomod."|grep '^module' | awk '{printf $2}'")

    function! s:go_import(pk)
        let gomod = system('bash /vagrant_data/shs/getpwd.sh')
        let gomoduleprefix = system("cat ".gomod."|grep '^module' | awk '{printf $2}'")
        let pack = gomoduleprefix."/". a:pk
        execute 'GoImport' pack

        let packpostfix = system("echo ".a:pk."|awk -F '/' '{printf $NF}'")
        execute 'normal o' packpostfix
    endfunction

    let cachefile = system("cat ".gomod."| grep '^module'|awk '{printf $2}' | sed 's/\\./_/g' |sed 's#/#_#g'")
    echom cachefile

    if filereadable(expand("/tmp/".cachefile)) && a:flag == 1
        let cmd_str = "cat /tmp/".cachefile
    else
        let cmd_str = "cd ".workspace." && go list ./... | sed 's#".gomoduleprefix."/##g' | sort | uniq | tee /tmp/".cachefile
        echom cmd_str
    endif

    call fzf#run(fzf#wrap({'source': cmd_str, 'sink': function('s:go_import')}))
endfunction


function! s:get_go_doc()
    function! s:go_doc(pk)
    execute 'GoDoc' a:pk
    endfunction
    call fzf#run(fzf#wrap({'source': 'gopkgs | sort | uniq', 'sink': function('s:go_doc')}))
endfunction
augroup gopkgs
    autocmd!
    autocmd FileType go command! -buffer GW exe s:get_workspace_pkgs(1)
    autocmd FileType go command! -buffer GWR exe s:get_workspace_pkgs(2)
    autocmd FileType go command! -buffer GLN exe s:get_lib_pkgs(1)
    autocmd FileType go command! -buffer GLM exe s:get_lib_pkgs(2)
    autocmd FileType go command! -buffer GS exe s:get_std_pkgs()
    autocmd FileType go command! -buffer GD exe s:get_go_doc()
augroup END

map <leader>i :GI<cr>
map <leader>d :GD<cr>



fun! VimspectorConfigGen()    
      let cur_line = line(".")    
      execute "normal yaf"    
      execute cur_line
      lua X = function(a) local _,_, funcName = string.find(a, 'func +([A-Za-z_]*)'); return funcName end
      let funcName = luaeval('X(_A[1])', [@@])
      echom funcName

      if &filetype == 'c'    
          call system("bash /vagrant_data/shs/vimspector_config/gen_c.sh " . funcName)  
      elseif &filetype == 'go'    
          call system("bash /vagrant_data/shs/vimspector_config/gen_go.sh " . funcName)  
      elseif &filetype == 'py'    
          call system("bash /vagrant_data/shs/vimspector_config/gen_py.sh " . funcName)  
      elseif &filetype == 'php'    
          call system("bash /vagrant_data/shs/vimspector_config/gen_php.sh " . funcName)  
      elseif &filetype == 'lua'    
         call system("bash /vagrant_data/shs/vimspector_config/gen_lua.sh " . funcName)      
      endif        
endfun

fun! Toggle_database()
    let $DATABASE_URL=system("make sql| tr -d '\n\r'")
endfun


fun! Toggle_debug()
    if !exists('b:qmode_debug')
      
        call VimspectorConfigGen()

        if filereadable('Makefile')
            let $EXEC_FILE=system("make out")
        endif
      
       let b:qmode_debug = 1
       if &filetype == 'java'
         nmap b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
         nmap c <Cmd>lua require'dap'.continue()<CR>
         nmap n <Cmd>lua require'dap'.step_over()<CR>
         nmap ui <Cmd>lua require("dapui").toggle()<CR>
         nmap e <Cmd>lua require("dapui").eval()<CR>
         nmap rs <Cmd>lua require'dap'.terminate()<CR>
      else
         nmap b <Plug>VimspectorToggleBreakpoint
         nmap bc <Plug>VimspectorToggleConditionalBreakpoint
         nmap bf <Plug>VimspectorAddFunctionBreakpoint
         nmap c <Plug>VimspectorContinue
         nmap n <Plug>VimspectorStepOver
         nmap si <Plug>VimspectorStepInto
         nmap so <Plug>VimspectorStepOut
         nmap e <Plug>VimspectorBalloonEval
         nmap fd <Plug>VimspectorDownFrame
         nmap fu <Plug>VimspectorUpFrame	
         nmap t :call GenTest()<CR>
         nmap rs :VimspectorReset<CR>


      endif
    else
         unlet b:qmode_debug
         unmap b
         unmap bc
         unmap bf
         unmap c
         unmap n
         unmap fu
         unmap fd
         unmap si
         unmap so
         unmap t
         unmap ui 
     endif
endfun




func! RunProgram()    
      exec "w"    
      if &filetype == 'c'    
         exec "!gcc % -o %<"    
         exec "! ./%<"    
      elseif &filetype == 'cpp'    
         exec "!g++ % -o %<"    
         exec "! ./%<"    
      elseif &filetype == 'sh'
        TermExec cmd="clear && echo && bash %"   
      elseif &filetype == 'go'    
         TermExec cmd="clear && echo && go run %"   
      elseif &filetype == 'python'    
         TermExec cmd="clear && echo && python3 %"    
      elseif &filetype == 'php'    
         TermExec cmd="clear && echo && php %"    
      elseif &filetype == 'lua'  
          TermExec cmd="clear && echo && lua %"     
      elseif &filetype == 'java'    
         exec "!javac %"    
         exec "!java -cp %:p:h %:t:r"    
      endif    
  endfunc    

  func! Run_Ranger() 
       exec "FloatermNew --height=0.6 --width=0.4 --wintype=float --name=floaterm1 --position=topleft ranger"    
  endfunc
 
fu! s:isdir(dir) abort
      return !empty(a:dir) && (isdirectory(a:dir) ||
      \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))
endfu



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


fun! Toggle_debug_vim()
    if !exists('b:qmode_vim')
      exec "w"    
    
        let b:qmode_vim = 1
         nmap b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
         nmap c <Cmd>lua require'dap'.continue()<CR>
         nmap n <Cmd>lua require'dap'.step_over()<CR>
         nmap e <Cmd>lua require'dap'.repl.open()<CR>
         nmap rs <Cmd>lua require'dap'.terminate()<CR>
     else
         unlet b:qmode_vim
         unmap b
         unmap c
         unmap n
         unmap e
         unmap rs
     endif
endfun

fun! Run_vim_server()
   lua require"osv".launch({port=8086})
endfun

fun! JsonPrettyFun()
    let @a = system("jq . ". bufname("%"))
    if v:shell_error
        echom @a
    else
        %delete
        normal! "ap
        1delete
        write
    endif
endfun

fun! JsonMinFun()
    let @a = system("jq -c . < ". bufname("%"))
    if v:shell_error
        echom @a
    else
        %delete
        normal! "ap
        1delete
        write
    endif
endfun

fun! MkView()
    let fileName =  expand('%:t')
    let preFileName = "_pre-".fileName
    execute "silent!cp ".fileName . " ".preFileName
    execute "!bash /vagrant_data/shs/mkinc.sh ".fileName
    execute "edit ".preFileName
    execute "MarkdownPreview"
endfun

function! s:goyo_enter()
   lua require('lualine').hide()
   Limelight
   PencilSoft
endfunction

function! s:goyo_leave()
   Limelight!
   PencilOff
endfunction

let g:pencil#conceallevel = 0
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()



EOF

cat <<EOF > ~/.config/nvim/cmd.vim
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --hidden --ignore-case --ignore-file ~/.fzf_ignore --no-heading --color=always '.<q-args>, 1,
    \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
    \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
    \   <bang>0)
command Gg call system('echo '.expand("%"). '>> .git/info/exclude')

command! ToggleDebugVim call  Toggle_debug_vim()
command! ToggleDebug    call  Toggle_debug()
command! RunVimServer   call  Run_vim_server()
command! Ranger         call  Run_Ranger()
command! JsonMin         call  JsonMinFun()
command! JsonPretty         call  JsonPrettyFun()
command! MkView         call  MkView()
command! ToggleDatabase    call  Toggle_database()
EOF

mkdir -p ~/.config/nvim/after/plugin



cat <<'EOF' > ~/.config/nvim/after/plugin/toggleterm.rc.vim
  " set
  let g:toggleterm_terminal_mapping = '<C-t>'
  " or manually...
  autocmd TermEnter term://*toggleterm#*
        \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

  " By applying the mappings this way you can pass a count to your
  " mapping to open a specific window.
  " For example: 2<C-t> will open terminal 2
  nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
  inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
EOF









proxy  && \
nvim  -c 'autocmd User PackerComplete quitall' -c 'PackerSync' && \
nvim  +TSUpdate +qa && \
noproxy




