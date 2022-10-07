let s:words = ["0=end", "0=else", "0=elsif", "0=when", "0=in", "0=rescue", "0=ensure", "0==begin", "0==end"]
let s:characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_?!:"

let s:indent_words = ["0)", "0]", "0}", "0.", "0=..", "0=&.", "o", "O", "!^F"]

for s:word in s:words
  call add(s:indent_words, s:word)

  for char in s:characters
    call add(s:indent_words, s:word..char)
  endfor
endfor

let g:indent_words = s:indent_words->join(",")

unlet s:words s:characters s:word s:indent_words
