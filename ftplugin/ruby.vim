" Vim ftplugin file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, 'did_ftplugin')
  finish
endif

let b:did_ftplugin = 1

setlocal
      \ shiftwidth=2
      \ comments=:#
      \ commentstring=#\ %s
      \ suffixesadd=.rb

let b:undo_ftplugin = "setlocal shiftwidth< comments< commentstring< suffixesadd<"

" matchit.vim
if get(g:, "loaded_matchit")
  let b:match_words = '\<\%(def\|class\|module\|if\|unless\|case\|while\|until\|for\|begin\|do\)\:\@!\>:\<\%(else\|elsif\|when\|in\|rescue\|ensure\|break\|next\|yield\|return\|raise\|redo\|retry\)\:\@!\>:\<end\:\@!\>'
  let b:match_skip = 'S:^ruby\%(Keyword\|Define\)$'

  let b:undo_ftplugin ..= " | unlet! b:match_words b:match_skip"
endif
