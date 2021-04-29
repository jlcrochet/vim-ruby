" Vim autoload file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

let g:eruby#ftplugin#extensions = {
      \ "html": "html",
      \ "js": "javascript",
      \ "json": "json",
      \ "yml": "yaml",
      \ "txt": "text",
      \ "md": "markdown"
      \ }

if exists("g:eruby_extensions")
  call extend(g:eruby#ftplugin#extensions, g:eruby_extensions)
endif

lockvar g:eruby#ftplugin#extensions
