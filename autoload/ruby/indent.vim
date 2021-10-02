" Vim autoload file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

" There are certain keywords that cause a dedent, but a dedent should
" only occur if the word is not succeeded by a keyword character, in
" order to avoid dedenting when a line has a variable named "end_col" or
" something like that.
let s:dedent_words = []

let s:chars = map(str2list("abcdefghijklmnopqrstuvwxyz0123456789_:"), "nr2char(v:val)")

for s:word in ["begin", "end", "else", "elsif", "when", "in", "rescue", "ensure", "=begin", "=end"]
  let str = "0=" .. s:word

  call add(s:dedent_words, str)

  for char in s:chars
    call add(s:dedent_words, str .. char)
  endfor
endfor

const g:ruby#indent#dedent_words = join(s:dedent_words, ",")

unlet s:word s:chars s:dedent_words
