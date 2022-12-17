" Vim syntax file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

let b:is_eruby = 1

unlet! b:current_syntax

syn include @ruby syntax/ruby.vim

let b:current_syntax = "eruby"

syn cluster eruby contains=erubyTag,erubyComment,erubyTagEscape

syn region erubyTag matchgroup=erubyDelimiter start=/\%#=1<%-\==\=/ end=/\%#=1-\=%>/ contains=@ruby containedin=ALLBUT,@ruby,@eruby
syn region erubyComment matchgroup=erubyCommentStart start=/\%#=1<%#/ matchgroup=erubyCommentEnd end=/\%#=1%>/ containedin=ALLBUT,@ruby,@eruby
syn match erubyTagEscape /\%#=1<%%/ containedin=ALLBUT,@ruby,@eruby

hi def link erubyDelimiter PreProc
hi def link erubyComment Comment
hi def link erubyCommentStart erubyComment
hi def link erubyCommentEnd erubyCommentStart
hi def link erubyTagEscape erubyDelimiter
