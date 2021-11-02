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

syn region erubyTag matchgroup=erubyDelimiter start=/\%#=1<%-\==\=/ end=/\%#=1-\=%>/ contains=@ruby containedin=ALLBUT,erubyTag,erubyComment,erubyTagEscape,@ruby
syn region erubyComment matchgroup=erubyCommentStart start=/\%#=1<%#/ matchgroup=erubyCommentEnd end=/\%#=1%>/ containedin=ALLBUT,erubyTag,erubyComment,erubyTagEscape,@ruby
syn match erubyTagEscape /\%#=1<%%/ containedin=ALLBUT,erubyTag,erubyComment,erubyTagEscape,@ruby

hi def link erubyDelimiter PreProc
hi def link erubyComment Comment
hi def link erubyCommentStart erubyComment
hi def link erubyCommentEnd erubyCommentStart
hi def link erubyTagEscape erubyDelimiter
