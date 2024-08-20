" Vim indent file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, 'did_indent')
  finish
endif

if exists(b:eruby_subtype)
  call ruby#subtype#source_indent(b:eruby_subtype)
  let b:eruby_subtype_indentexpr = &indentexpr
else
  let b:eruby_subtype_indentexpr = '-1'
endif

setlocal
      \ indentexpr=GetErubyIndent()
      \ indentkeys+==end,=else,=elsif

let b:did_indent = 1

if exists("*GetErubyIndent")
  finish
endif

let s:start_re = '[([{]\|\C\v<%(if|unless|begin|do)>'
let s:middle_re = '\C\v<%(else|elsif)>'
let s:end_re = '[)\]}]\|\C\<end\>'

let s:skip_expr = 'synID(line("."), col("."), 0)->synIDattr("name") !~# ''^ruby\%(Delimiter\|Keyword\)$'''

function GetErubyIndent() abort
  if searchpair(s:start_re, s:middle_re, s:end_re, "cnz", s:skip_expr, v:lnum)
    return indent(searchpair(s:start_re, s:middle_re, s:end_re, "bW", s:skip_expr))
  endif

  let prev_lnum = prevnonblank(v:lnum - 1)

  if prev_lnum == 0
    return 0
  endif

  if searchpair(s:start_re, s:middle_re, s:end_re, "b", s:skip_expr, prev_lnum)
    return indent(prev_lnum) + shiftwidth()
  endif

  return eval(b:eruby_subtype_indentexpr)
endfunction
