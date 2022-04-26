" Vim ftplugin file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet@hey.com>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, "did_ftplugin")
  finish
endif

setlocal suffixesadd=.erb
let b:undo_ftplugins = "setl suffixesadd<"

" Determine the sub-filetype based on the file extension of the file
" being opened.
let s:parts = split(expand("<afile>"), '\.')

if len(s:parts) > 2
  let s:sub_extension = s:parts[-2]

  if has_key(g:eruby#ftplugin#extensions, s:sub_extension)
    let b:eruby_subtype = g:eruby#ftplugin#extensions[s:sub_extension]
  endif
elseif s:parts[-1] ==# "rhtml"
  let b:eruby_subtype = "html"
else
  let b:eruby_subtype = g:eruby#ftplugin#default_subtype
endif

unlet! s:parts s:sub_extension

" If a subtype was found, load filetype settings for that subtype.
if exists("b:eruby_subtype")
  execute printf("runtime! ftplugin/%s.vim ftplugin/%s_*.vim ftplugin/%s/*.vim indent/%s.vim", b:eruby_subtype, b:eruby_subtype, b:eruby_subtype, b:eruby_subtype)

  if has("nvim")
    execute printf("runtime! ftplugin/%s.lua ftplugin/%s_*.lua ftplugin/%s/*.lua indent/%s.lua", b:eruby_subtype, b:eruby_subtype, b:eruby_subtype, b:eruby_subtype)
  endif

  let b:eruby_subtype_indentexpr = &indentexpr
  let &indentkeys .= ",=end,=else,=elsif"

  unlet b:did_indent
else
  let b:eruby_subtype_indentexpr = "-1"

  setlocal
        \ shiftwidth=2
        \ commentstring=<%#\ %s\ %>
        \ indentkeys==end,=else,=elsif

  let b:undo_ftplugin .= " setl shiftwidth< commentstring< indentkeys<"
endif

let b:did_ftplugin = 1
