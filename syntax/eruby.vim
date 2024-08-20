" Vim syntax file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if exists('b:current_syntax')
  finish
endif

if exists('b:eruby_subtype')
  call ruby#subtype#source_syntax(b:eruby_subtype)
endif

let b:is_eruby = 1
syn include @erubyRuby syntax/ruby.vim

let b:current_syntax = "eruby"

syn cluster erubyTop contains=TOP

syn region erubyTag matchgroup=erubyDelimiter start=/\%#=1<%-\==\=/ end=/\%#=1-\=%>/ contains=@erubyRuby containedin=ALLBUT,@erubyRuby,@erubyTop
syn region erubyComment matchgroup=erubyCommentStart start=/\%#=1<%#/ matchgroup=erubyCommentEnd end=/\%#=1%>/ containedin=ALLBUT,@erubyRuby,@erubyTop
syn match erubyTagEscape /\%#=1<%%/ containedin=ALLBUT,@erubyRuby,@erubyTop

hi def link erubyDelimiter Delimiter
hi def link erubyComment Comment
hi def link erubyCommentStart erubyComment
hi def link erubyCommentEnd erubyCommentStart
hi def link erubyTagEscape erubyDelimiter
