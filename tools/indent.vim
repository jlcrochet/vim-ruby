let s:words = ["0=end", "0=else", "0=elsif", "0=when", "0=in", "0=rescue", "0=ensure", "0==begin", "0==end"]
let s:characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_?!:"

let s:indent_words = ["0)", "0]", "0}", "0.", "0=..", "0=&.", "o", "O", "!^F"]

for s:word in s:words
  call append(s:indent_wordswords, word)

  for s:char in s:characters
    call append(s:indent_words, s:word..s:char)
  endfor
endfor

let g:indentkeys = s:indent_words->join(",")

unlet s:words s:characters s:word s:char s:indent_words
