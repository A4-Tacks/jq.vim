" Vim indent file
" Language:	jq
" Maintainer:	A4-Tacks <wdsjxhno1001@163.com>
" Last Change:	2025 01 08
" Upstream:	https://github.com/vito-c/jq.vim

if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

function! GetJqIndent(lnum) abort
    let lnum = a:lnum
    let pnum = prevnonblank(lnum - 1)
    let cline = substitute(getline(lnum), '\v\s*%(\|\s*)?%(#.*)?$', '', '')
    let pline = substitute(getline(pnum), '\v\s*%(\|\s*)?%(#.*)?$', '', '')
    let pindent = pnum ? indent(pnum) : 0
    let indent = 0

    if pline =~# '\v^\s*%(\|\s*)?%(def|try|then|if|elif|else)>|[:{([]$'
                \|| pline =~# '\v<%(try|then|if|elif|else)$'
        if pline !~# '\v<end%(\s*[;,])?$' || pline =~# '\v^\s*%(\|\s*)?def>'
            let indent += 1
        endif
    endif
    if cline =~# '\v^\s*%(\|\s*)?%(%(then|elif|else|end|catch)>|[})\]])'
        let indent -= 1
    endif
    if pline =~# ';$'
        let name = synIDattr(synID(pnum, match(pline, ';$')+1, 1), 'name')
        if name ==# 'jqNameDefinitionBody'
            let indent -= 1
        endif
    endif

    return pindent + indent*&shiftwidth
endfunction

setlocal indentexpr=GetJqIndent(v:lnum)
setlocal indentkeys+=0},0],0),=then,=end,=catch,=elif,=else,=;
setlocal nosmartindent
