#!/bin/bash
source /vagrant_data/shs/utils.sh
echo "go vim install"
# golang
function install_go_server(){
    SERVER_VERSION=$1
    if [ -f  /usr/local/go/bin/go ]
    then
        echo "go had installed"
        return
    fi

    if [ ! -f  go${SERVER_VERSION}.linux-amd64.tar.gz ];then
         axel -n 40 -o go${SERVER_VERSION}.linux-amd64.tar.gz https://dl.google.com/go/go${SERVER_VERSION}.linux-amd64.tar.gz && \
        sudo  tar -C /usr/local -xzf  go${SERVER_VERSION}.linux-amd64.tar.gz && \
        sudo rm -rf go${SERVER_VERSION}.linux-amd64.tar.gz 
    fi
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
     echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.zshrc
     echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bashrc
    ~/.local/share/nvim/site/pack/packer/start/vimspector/install_gadget.py --sudo --no-check-certificate --enable-go


}

install_go_server 1.19.2


function go_vim_ins(){
    ! (grep -F 'fatih/vim-go' ~/.config/nvim/lua/plugins.lua &>/dev/null ) && \
    sed -i "/plugAddPoint/ause 'fatih/vim-go'" ~/.config/nvim/lua/plugins.lua
    export PATH=$PATH:/usr/local/go/bin:~/go/bin
    echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.zshrc
    echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bashrc
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn
    proxy && \
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' && \
    nvim +'GoInstallBinaries' +qall && \
    #go get -u github.com/cweill/gotests/...
    go install github.com/cweill/gotests/...@latest
    ! ( grep -F "leetcode_solution_filetype" ~/.config/nvim/init.vim ) && \
    cat >> ~/.config/nvim/init.vim <<END
    let g:leetcode_solution_filetype='golang'
END
}

go_vim_ins

if [ ! -f /usr/local/bin/gopkgs  ];then
	wget https://github.com/haya14busa/gopkgs/releases/download/v1.0.0/gopkgs_linux_amd64 && sudo mv gopkgs_linux_amd64 /usr/local/bin/gopkgs && chmod u+x /usr/local/bin/gopkgs
fi

cat <<EOF >> ~/.config/nvim/settings.vim
    let g:vimspector_ui_mode = "vertical"
    let g:go_def_mapping_enabled = 0
EOF



cat <<EOF >> ~/.config/nvim/maps.vim
    autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
    map  <leader>ef  :call ExtraFunc()<CR
EOF



cat <<'EOF' >> ~/.config/nvim/func.vim
   
 


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






fun! Toggle_test_go()
    if !exists('b:go_test_mode')
        let b:go_test_mode = 1
        nmap t :call GenTest()<CR>
     else
        unlet b:go_test_mode
        unmap t
     endif
endfun

function! s:CustomiseUI()    
  let wins = g:vimspector_session_windows    
     
  " Close the Variables window    
  call win_execute( wins.variables, 'q' )    
  call win_execute( wins.stack_trace, 'q' )    
  call win_execute( wins.watches, 'q' )    
  call win_execute( wins.tabpage, 'q' )    
     
     
  call win_gotoid( wins.code )    
  resize 60    
     
  call win_gotoid( wins.output )    
  resize 5    
     
endfunction    
     
augroup TestUICustomistaion    
  autocmd!    
  autocmd User VimspectorUICreated call s:CustomiseUI()    
augroup END

EOF

cat <<EOF >> ~/.config/nvim/cmd.vim
command! ToggleTestGo call Toggle_test_go()
EOF

