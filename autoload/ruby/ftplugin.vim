" Vim autoload file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@hey.com>
" URL: https://github.com/jlcrochet/vim-ruby

" matchit.vim
let s:match_words = [
      \ '\<\%(def\|class\|module\|if\|unless\|case\|while\|until\|for\|begin\|do\)\:\@!\>',
      \ '\<\%(else\|elsif\|when\|in\|rescue\|ensure\|break\|next\|yield\|return\|raise\|redo\|retry\)\:\@!\>',
      \ '\<end\:\@!\>'
      \ ]
const g:ruby#ftplugin#match_words = join(s:match_words, ":")
unlet s:match_words
