" Vim autoload file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

let s:extensions = #{
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
  call extend(s:extensions, g:eruby_extensions)
endif

let s:default_subtype = get(g:, "eruby_default_subtype", "html")

if s:default_subtype !=# ""
  function g:eruby#ftdetect#set_filetype()
    let parts = split(expand("<afile>"), '\.')

    if len(parts) > 2
      let subtype = get(s:extensions, parts[-2], s:default_subtype)
    else
      let subtype = s:default_subtype
    endif

    let &filetype = subtype..".eruby"
  endfunction
else
  function g:eruby#ftdetect#set_filetype()
    let parts = split(expand("<afile>"), '\.')

    if len(parts) > 2
      let part = parts[-2]

      if has_key(s:extensions, part)
        let &filetype = s:extensions[part]..".eruby"
      else
        setfiletype eruby
      endif
    else
      setfiletype eruby
    endif
  endfunction
endif
