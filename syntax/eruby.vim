" Vim syntax file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if exists("b:current_syntax")
  finish
endif

if exists("b:eruby_subtype")
  execute "runtime! syntax/".b:eruby_subtype.".vim"
  unlet b:current_syntax
endif

let b:is_eruby = 1

syn include @ruby syntax/ruby.vim

let b:current_syntax = "eruby"

syn region erubyTag matchgroup=erubyDelimiter start=/\%#=1<%-\==\=/ end=/\%#=1-\=%>/ contains=@ruby
syn region erubyComment matchgroup=erubyCommentDelimiter start=/\%#=1<%#/ end=/\%#=1%>/
syn match erubyTagEscape /\%#=1<%%/

hi def link erubyDelimiter PreProc
hi def link erubyComment Comment
hi def link erubyCommentDelimiter erubyComment
hi def link erubyTagEscape erubyDelimiter
