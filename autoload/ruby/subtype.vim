" Vim autoload file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

function ruby#subtype#source_syntax(ft) abort
  execute printf('runtime! syntax/%s.vim syntax/%s/*.vim', a:ft, a:ft)

  if has('nvim')
    execute printf('runtime! syntax/%s.lua syntax/%s/*.lua', a:ft, a:ft)
  endif

  unlet! b:current_syntax
endfunction

function ruby#subtype#source_indent(ft) abort
  execute printf('runtime! indent/%s.vim', a:ft)

  if has('nvim')
    execute printf('runtime! indent/%s.lua', a:ft)
  endif

  unlet! b:did_indent
endfunction
