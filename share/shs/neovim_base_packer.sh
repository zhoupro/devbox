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
rm -f ~/.config/nvim/init.vim
mkdir -p  ~/.config/nvim/lua && \
cp /vagrant_data/conf/nvim/plugins.lua  ~/.config/nvim/lua/plugins.lua


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
    set hlsearch
    set incsearch
    set nu
    set list
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set foldmethod=manual
   
    let g:vimspector_enable_mappings = 'HUMAN'
    let test#strategy='neovim'
    let g:airline_section_z = 'happy'
    set cmdheight=2
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_auto_save = 1
     autocmd Filetype json let g:indentLine_enabled = 0

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
    nmap <silent> gic :CocCommand  document.showIncomingCalls<CR>
    map  ma  :call Mybks()<CR>

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

EOF

mkdir -p ~/.config/nvim/after/plugin

cat <<'EOF' > ~/.config/nvim/after/plugin/markdown.rc.vim
    let g:vim_markdown_folding_disabled = 1
EOF


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






cat <<EOF > ~/.config/nvim/coc-settings.json

{
  "suggest.triggerAfterInsertEnter": true,
  "suggest.noselect": false,
  "python.linting.enabled": false,
  "python.jediEnabled": false,
  "suggest.timeout": 3500,
  "suggest.minTriggerInputLength": 2,
  "suggest.echodocSupport": true,
  "Lua.diagnostics.enable":false,
  "suggest.enablePreview": false,
  "go.goplsOptions": {
      "analyses": { "unsafeptr": false }
  },
  "Lua.telemetry.enable": true, 
  "Lua.runtime.path":["/usr/local/share/lua/5.3/?.lua","/usr/local/share/lua/5.3/?/init.lua","/usr/local/lib/lua/5.3/?.lua","/usr/local/lib/lua/5.3/?/init.lua","/usr/share/lua/5.3/?.lua","/usr/share/lua/5.3/?/init.lua","./?.lua","./?/init.lua","/root/.config/awesome/?.lua","/root/.config/awesome/?/init.lua","/etc/xdg/awesome/?.lua","/etc/xdg/awesome/?/init.lua","/usr/share/awesome/lib/?.lua","/usr/share/awesome/lib/?/init.lua"],
  "Lua.workspace.library":["/usr/share/awesome/lib"],   
  "sumneko-lua.enableNvimLuaDev":true,    
  "Lua.diagnostics.globals":["vim", "awesome"],    
  "Lua.completion.showWord":"Disable"
}

EOF


proxy
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless +TSUpdate +qa
noproxy

nvim "+CocInstall -sync coc-snippets" +qall 



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
