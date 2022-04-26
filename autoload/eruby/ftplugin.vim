" Vim autoload file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet@hey.com>
" URL: https://github.com/jlcrochet/vim-ruby

let g:eruby#ftplugin#extensions = #{
      \ html: "html",
      \ turbo_stream: "html",
      \ js: "javascript",
      \ json: "json",
      \ xml: "xml",
      \ yml: "yaml",
      \ txt: "text",
      \ md: "markdown"
      \ }

if exists("g:eruby_extensions")
  call extend(g:eruby#ftplugin#extensions, g:eruby_extensions)
endif

lockvar g:eruby#ftplugin#extensions

let g:eruby#ftplugin#default_subtype = get(g:, "eruby_default_subtype", "html")
