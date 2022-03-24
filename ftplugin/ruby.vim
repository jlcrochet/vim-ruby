" Vim ftplugin file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, 'did_ftplugin')
  finish
endif

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
let b:match_words = g:ruby#ftplugin#match_words
let b:match_skip = 's:^ruby\%(String\|Symbol\|Regex\|Comment\|PostfixKeyword\|MethodDefinition\|VariableOrMethod\)$'

let b:undo_ftplugin = "setl shiftwidth< comments< commentstring< suffixesadd<"

let b:did_ftplugin = 1
