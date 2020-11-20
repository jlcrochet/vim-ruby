" Vim indent file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, "did_indent")
  finish
endif

let b:did_indent = 1

setlocal indentkeys=0),0],0},.,o,O,!^F
setlocal indentkeys+=0=else,0=elsif,0=when,0=in,0=rescue,0=ensure
setlocal indentkeys+==begin,=end

if has("nvim-0.5")
  lua get_ruby_indent = require("get_ruby_indent")
  setlocal indentexpr=v:lua.get_ruby_indent()
  finish
endif

setlocal indentexpr=GetRubyIndent(v:lnum)

if exists("*GetRubyIndent")
  finish
endif

const s:skip_char = "get(g:ruby#multiline_regions, synID(line('.'), col('.'), 0))"
const s:skip_word = "synID(line('.'), col('.'), 0) != g:ruby#keyword"

const s:hanging_re = '\v<%(if|unless|begin|case)>'
const s:postfix_re = '\v<%(if|unless|while|until|rescue)>'
const s:exception_re = '\v<%(begin|do|def)>'
const s:list_re = '\v<%(begin|do|if|unless)>'

const s:start_re = s:hanging_re.'|<%(while|until|for|do|def|class|module)>'
const s:middle_re = '\v<%(else|elsif|when|rescue|ensure)>'

" Similar to the `skip_word` expression above, but includes logic for
" skipping postfix `if` and `unless`.
function! s:skip_word_postfix_temp() abort
  let lnum = line(".")
  let col = col(".")

  if synID(lnum, col, 0) != g:ruby#keyword
    return 1
  endif

  let word = expand("<cword>")

  if word =~# s:postfix_re
    let [_, col] = searchpos('\S', "b", lnum)

    if !col
      return 0
    endif

    if synID(lnum, col, 0) != g:ruby#operator
      return 1
    endif
  endif

  return 0
endfunction

const s:skip_word_postfix = function("s:skip_word_postfix_temp")

" Find the nearest line up to and including the given line that does not
" begin with a multiline region.
function! s:prev_non_multiline(lnum) abort
  let lnum = a:lnum

  while get(g:ruby#multiline_regions, synID(lnum, 1, 0))
    let lnum = prevnonblank(lnum - 1)
  endwhile

  return lnum
endfunction

function! s:get_last_char() abort
  let [lnum, col] = searchpos('\S', "bW")

  if !lnum
    return
  endif

  let synid = synID(lnum, col, 0)

  while synid == g:ruby#comment || synid == g:ruby#comment_delimiter
    let [lnum, col] = searchpos('\S\_s*\%(#\|=begin\>\)', "bW")

    if !lnum
      return
    endif

    let synid = synID(lnum, col, 0)
  endwhile

  let line = getline(lnum)
  let char = line[col - 1]

  return [char, synid, lnum, col]
endfunction

function! s:get_msl(lnum) abort
  let lnum = s:prev_non_multiline(a:lnum)

  let line = getline(lnum)
  let [first_char, first_idx, second_idx] = matchstrpos(line, '\S')

  " This line is *not* the MSL if:
  " 1. It starts with a leading dot
  " 2. It starts with a closing bracket
  " 3. It starts with `end` or `=end`
  " 4. The previous line ended with a comma or hanging operator

  if first_char == "." && line[second_idx] != "."
    return s:get_msl(prevnonblank(lnum - 1))
  elseif first_char == ")"
    call cursor(lnum, 1)

    let found = searchpair("(", "", ")", "bW", s:skip_char)

    return s:get_msl(found)
  elseif first_char == "]"
    call cursor(lnum, 1)

    let found = searchpair('\[', "", "]", "bW", s:skip_char)

    return s:get_msl(found)
  elseif first_char == "}"
    call cursor(lnum, 1)

    let found = searchpair("{", "", "}", "bW", s:skip_char)

    return s:get_msl(found)
  elseif first_char ==# "e" && match(line, '^nd\>', second_idx) > -1
    " As an optimization, we are not doing the search if the `end` has
    " no whitespace before it, indicating that there is no possibility
    " for a hanging indent.
    if first_idx == 0
      return lnum
    endif

    call cursor(lnum, 1)

    let found = searchpair(s:start_re, "", '\<end\>', "bW", s:skip_word_postfix)
    let word = expand("<cword>")

    if word ==# "do" || word =~# s:hanging_re
      return s:get_msl(found)
    else
      return found
    endif
  elseif first_char == "=" && match(line, '^end\>', second_idx) > -1
    call cursor(lnum, 1)

    let found = search('\_^=begin\>', "bW")

    return s:get_msl(found - 1)
  else
    call cursor(lnum, 1)

    let [last_char, synid, prev_lnum, _] = s:get_last_char()

    if last_char == "," || last_char == '\' || synid == g:ruby#operator
      return s:get_msl(prev_lnum)
    elseif synid == g:ruby#keyword
      let word = expand("<cword>")

      if word ==# "or" || word ==# "and"
        return s:get_msl(prev_lnum)
      endif
    endif
  endif

  " If none of the above are true, this line is the MSL.
  return lnum
endfunction

" Modified version of the above that does not consider commas to be
" continuation starters; this is specifically for use inside of
" multiline list-like regions where we do not want to traverse all the
" way back to the beginning of the list to determine the indentation for
" an item.
function! s:get_list_msl(lnum) abort
  let lnum = s:prev_non_multiline(a:lnum)

  let line = getline(lnum)
  let [first_char, first_idx, second_idx] = matchstrpos(line, '\S')

  " This line is *not* the MSL if:
  " 1. It starts with a leading dot
  " 2. It starts with a closing bracket
  " 3. It starts with `end` or `=end`
  " 4. The previous line ended with a comma or hanging operator

  if first_char == "." && line[second_idx] != "."
    return s:get_list_msl(prevnonblank(lnum - 1))
  elseif first_char == ")"
    call cursor(lnum, 1)

    let found = searchpair("(", "", ")", "bW", s:skip_char)

    return s:get_list_msl(found)
  elseif first_char == "]"
    call cursor(lnum, 1)

    let found = searchpair('\[', "", "]", "bW", s:skip_char)

    return s:get_list_msl(found)
  elseif first_char == "}"
    call cursor(lnum, 1)

    let found = searchpair("{", "", "}", "bW", s:skip_char)

    return s:get_list_msl(found)
  elseif first_char ==# "e" && match(line, '^nd\>', second_idx) > -1
    call cursor(lnum, 1)

    let found = searchpair(s:list_re, "", '\<end\>', "bW", s:skip_word_postfix)

    return s:get_list_msl(found)
  elseif first_char == "=" && match(line, '^end\>', second_idx) > -1
    call cursor(lnum, 1)

    let found = search('\_^=begin\>', "bW")

    return s:get_list_msl(found - 1)
  else
    call cursor(lnum, 1)

    let [last_char, synid, prev_lnum, _] = s:get_last_char()

    if last_char == '\' || synid == g:ruby#operator
      return s:get_list_msl(prev_lnum)
    elseif synid == g:ruby#keyword
      let word = expand("<cword>")

      if word ==# "or" || word ==# "and"
        return s:get_list_msl(prev_lnum)
      endif
    endif
  endif

  " If none of the above are true, this line is the MSL.
  return lnum
endfunction

function! GetRubyIndent(lnum) abort
  " Current line {{{1
  " If the current line is inside of an ignorable multiline region, do
  " nothing.
  if get(g:ruby#multiline_regions, synID(a:lnum, 1, 0))
    return -1
  endif

  let line = getline(a:lnum)
  let [first_char, first_idx, second_idx] = matchstrpos(line, '\S')

  if first_idx > -1
    " If the first character is `=` and it is followed by `begin` or
    " `end`, return 0.
    if first_char == "=" && match(line, '^\%(begin\|end\)\>', second_idx) > -1
      return 0
    endif

    " If the first character of the current line is a leading dot, add an
    " indent unless the previous logical line also started with a leading
    " dot.
    let second_char = line[second_idx]

    if (first_char == "." && second_char != ".") || (first_char == "&" && second_char == ".")
      let prev_lnum = s:prev_non_multiline(prevnonblank(a:lnum - 1))
      let prev_line = getline(prev_lnum)
      let [first_char, first_idx, second_idx] = matchstrpos(prev_line, '\S')
      let second_char = line[second_idx]

      if (first_char == "." && second_char != ".") || (first_char == "&" && second_char == ".")
        return first_idx
      else
        return first_idx + shiftwidth()
      endif
    endif

    " If the first character is a closing bracket, align with the line
    " that contains the opening bracket.
    if first_char == ")"
      return indent(searchpair("(", "", ")", "bW", s:skip_char))
    elseif first_char == "]"
      return indent(searchpair("\\[", "", "]", "bW", s:skip_char))
    elseif first_char == "}"
      return indent(searchpair("{", "", "}", "bW", s:skip_char))
    endif

    " If the first word is a deindenting keyword, align with the nearest
    " indenting keyword.
    let first_word = matchstr(line, '^\l\w*', first_idx)

    call cursor(a:lnum, 1)

    if first_word ==# "end"
      let [lnum, col] = searchpairpos(s:start_re, s:middle_re, '\<end\>', "bW", s:skip_word_postfix)
      let word = expand("<cword>")

      if word =~# s:hanging_re
        return col - 1
      else
        return indent(lnum)
      endif
    elseif first_word ==# "else"
      let [_, col] = searchpairpos(s:hanging_re, s:middle_re, '\<end\>', "bW", s:skip_word_postfix)
      return col - 1
    elseif first_word ==# "elsif"
      let [_, col] = searchpairpos('\v<%(if|unless)', '\<elsif\>', '\<end\>', "bW", s:skip_word_postfix)
      return col - 1
    elseif first_word ==# "when"
      let [_, col] = searchpairpos('\<case\>', '\<when\>', '\<end\>', "bW", s:skip_word)
      return col - 1
    elseif first_word ==# "in"
      let [_, col] = searchpairpos('\<case\>', '\<in\>', '\<end\>', "bW", s:skip_word)
      return col - 1
    elseif first_word ==# "rescue"
      let [lnum, col] = searchpairpos(s:exception_re, '\<rescue\>', '\<end\>', "bW", s:skip_word)

      if expand("<cword>") ==# "begin"
        return col - 1
      else
        return indent(lnum)
      endif
    elseif first_word ==# "ensure"
      let [lnum, col] = searchpairpos(s:exception_re, '\v<%(rescue|else)>', '\<end\>', "bW", s:skip_word)

      if expand("<cword>") ==# "begin"
        return col - 1
      else
        return indent(lnum)
      endif
    endif
  endif

  " Previous line {{{1
  " Begin by finding the previous non-comment character in the file.
  let [last_char, synid, prev_lnum, last_col] = s:get_last_char()

  if last_char is 0
    return 0
  endif

  " The only characters we care about for indentation are operators and
  " delimiters.

  if synid == g:ruby#operator
    " If the last character was a hanging operator, add an indent unless
    " the line before it also ended with a hanging operator.
    call cursor(s:prev_non_multiline(prev_lnum), 1)

    let [_, synid, _, _] = s:get_last_char()

    if synid == g:ruby#operator
      return indent(prev_lnum)
    elseif synid == g:ruby#keyword
      let word = expand("<cword>")

      if word ==# "or" || word ==# "and"
        return indent(prev_lnum)
      endif
    endif

    return indent(prev_lnum) + shiftwidth()
  endif

  if synid == g:ruby#keyword
    let word = expand("<cword>")

    if word ==# "or" || word ==# "and"
      " `or` and `and` behave like operators.
      call cursor(s:prev_non_multiline(prev_lnum), 1)

      let [_, synid, _, _] = s:get_last_char()

      if synid == g:ruby#operator
        return indent(prev_lnum)
      elseif synid == g:ruby#keyword
        let word = expand("<cword>")

        if word ==# "or" || word ==# "and"
          return indent(prev_lnum)
        endif
      endif

      return indent(prev_lnum) + shiftwidth()
    endif
  endif

  if synid == g:ruby#delimiter
    " If the last character was an opening bracket or block parameter
    " delimiter, add an indent.
    if last_char =~ '[([{|]'
      return indent(prev_lnum) + shiftwidth()
    endif

    " If the last character was a backslash, add an indent unless the
    " line before it also ended with a backslash.
    if last_char == '\'
      call cursor(s:prev_non_multiline(prev_lnum), 1)

      let [last_char, synid, _, _] = s:get_last_char()

      if last_char == '\' && synid == g:ruby#delimiter
        return indent(prev_lnum)
      else
        return indent(prev_lnum) + shiftwidth()
      endif
    endif

    " If the last character was a comma, check the following:
    "
    " 1. If the comma is preceded by an unpaired opening bracket
    " somewhere in the same line, align with the bracket.
    " 2. If the next previous line also ended with a comma or it ended
    " with an opening bracket, align with the beginning of the previous
    " line.
    " 3. If the next previous lined ended with a hanging operator, add
    " an indent.
    " 4. If the previous line is not its own MSL, align with the MSL.
    " 5. Else, add an indent.
    if last_char == ","
      let [_, col] = searchpairpos('[([{]', "", '[)\]}]', "b", s:skip_char, prev_lnum)

      if col
        return col
      endif

      call cursor(prev_lnum, 1)
      let [last_char, synid, _, _] = s:get_last_char()

      if last_char is 0
        return indent(prev_lnum) + shiftwidth()
      endif

      if synid == g:ruby#delimiter && last_char =~ '[,([{]'
        return indent(prev_lnum)
      endif

      let msl = s:get_list_msl(prev_lnum)

      if msl != prev_lnum
        return indent(msl)
      endif

      return indent(prev_lnum) + shiftwidth()
    endif
  endif

  " MSL {{{1
  let msl = s:get_msl(prev_lnum)

  " Find the last keyword in the previous logical line.
  call cursor(prev_lnum, last_col)

  while search('\<\l', "b", msl)
    let lnum = line(".")
    let col = col(".")

    if synID(lnum, col, 0) != g:ruby#keyword
      continue
    endif

    let word = expand("<cword>")

    if word =~# s:postfix_re
      let [_, prev_col] = searchpos('\S', "b", lnum)

      if !prev_col
        return col - 1 + shiftwidth()
      endif

      if synID(lnum, prev_col, 0) == g:ruby#operator
        return col - 1 + shiftwidth()
      endif

      return indent(msl)
    elseif word =~# '\v<%(begin|case|ensure|else|elsif|when|then)>'
      return col - 1 + shiftwidth()
    elseif word =~# '\v<%(do|def|class|module)>'
      return indent(msl) + shiftwidth()
    elseif word ==# "in"
      " `in` is a bit of a weird case:
      "
      " If it is the first word on the line, add an indent.
      " If it is preceded by `for`, add an indent.
      " Else, do nothing.
      let [found_lnum, found_col] = searchpos('\<for\>', "b", msl)

      if found_lnum && synID(found_lnum, found_col, 0) == g:ruby#keyword
        return indent(msl) + shiftwidth()
      endif

      let found = search('\<', "b")

      if found != lnum
        return indent(msl) + shiftwidth()
      endif

      return indent(msl)
    else
      return indent(msl)
    endif
  endwhile
  " }}}1

  " Default
  return indent(msl)
endfunction

" vim:fdm=marker
