# GO IDE

## 写代码
### 代码提示
### 代码生成

## 查找和跳转

## 测代码
### 代码调试 and 单元测试

``` vimscript
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
```
#### 覆盖率
GoCoverage

#### 自动生成单侧

```vimscript
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
```
[gotests](https://github.com/cweill/gotests)

## 重构
函数重命名
`nmap <leader>rn <Plug>(coc-rename)`

运行
GoRun
GoTestFunc
GoTest

提取函数

## 其他语言支持
ts
sql

## 代码管码

## 部署代码


# 图书资料
[gobyexample](https://gobyexample.com/)