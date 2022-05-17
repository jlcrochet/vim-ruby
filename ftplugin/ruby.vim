" Vim ftplugin file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@hey.com>
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

if get(g:, "ruby_fold")
  let g:ruby_simple_indent = 0
  setlocal foldmethod=syntax
endif

" matchit.vim
let b:match_words = '\<\%(def\|class\|module\|if\|unless\|case\|while\|until\|for\|begin\|do\)\:\@!\>:\<\%(else\|elsif\|when\|in\|rescue\|ensure\|break\|next\|yield\|return\|raise\|redo\|retry\)\:\@!\>:\<end\:\@!\>'
let b:match_skip = 's:^ruby\%(String\|Symbol\|Regex\|Comment\|PostfixKeyword\|MethodDefinition\|VariableOrMethod\)$'

let b:undo_ftplugin = "setl shiftwidth< comments< commentstring< suffixesadd<"
