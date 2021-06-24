" Vim indent file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, "did_indent")
  finish
endif

let b:did_indent = 1

setlocal indentkeys=0),0],0},0.,0=..,o,O,!^F
setlocal indentkeys+=0=begin,0=end,0=else,0=elsif,0=when,0=in,0=rescue,0=ensure
setlocal indentkeys+=0==begin,0==end

" There are a lot of common words that begin with `in`, so we don't
" always want to dedent when the line begins with it.
setlocal indentkeys+=0=ina,0=inb,0=inc,0=ind,0=ine,0=inf,0=ing,0=inh,0=ini,0=inj,0=ink,0=inl,0=inm,0=inn,0=ino,0=inp,0=inq,0=inr,0=ins,0=int,0=inu,0=inv,0=inw,0=inx,0=iny,0=inz,0=in0,0=in1,0=in2,0=in3,0=in4,0=in5,0=in6,0=in7,0=in8,0=in9,0=in_

if has("nvim-0.5")
  lua require "get_ruby_indent"
  setlocal indentexpr=v:lua.get_ruby_indent()
  finish
endif

setlocal indentexpr=GetRubyIndent()

if exists("*GetRubyIndent")
  finish
endif

" Helpers {{{
let s:kw_start_re = '\C\v<%(def|class|module|if|unless|case|while|until|for|begin|do):@!>'
let s:kw_middle_re = '\v<%(else|elsif|when|in|rescue|ensure):@!>'
let s:kw_end_re = '\C\v<end:@!>'

let s:start_pair_re = s:kw_start_re . '|[([{]'
let s:end_pair_re = s:kw_end_re . '|[)\]}]'

let s:pair_re = '\C\v<%((def|class|module)|(if|unless|case|while|until|for|begin|do)|(else|rescue|ensure)|(elsif|when|in)):@!>|(<end:@!>)|([([{])|([)\]}])'

let s:floating_re = '\C\v<%((begin|case|for|if|unless|until|while)|(else|elsif|ensure|in|rescue|when)|(class|def|module)|(do)|(end)):@!>|([([{])|([)\]}])|(\|)'

if get(g:, "ruby_simple_indent")
  let s:skip_keyword_expr = 'synID(line("."), col("."), 1) != g:ruby#indent#keyword'
else
  function s:skip_keyword()
    let synid = synID(line("."), col("."), 1)
    return synid != g:ruby#indent#keyword && synid != g:ruby#indent#define && synid != g:ruby#indent#block_control && synid != g:ruby#indent#define_block_control
  endfunction

  function s:skip_pair()
    let synid = synID(line("."), col("."), 1)
    return synid != g:ruby#indent#keyword && synid != g:ruby#indent#define && synid != g:ruby#indent#block_control && synid != g:ruby#indent#define_block_control && synid != g:ruby#indent#delimiter
  endfunction

  let s:skip_keyword_expr = function("s:skip_keyword")
  let s:skip_pair_expr = function("s:skip_pair")
endif

function s:prev_non_multiline(lnum)
  let lnum = a:lnum

  while get(g:ruby#indent#multiline_regions, synID(lnum, 1, 1))
    let lnum -= 1
  endwhile

  return lnum
endfunction

function s:is_hanging_operator(char, lnum, col)
  if a:char =~# '[%&+\-*/?:<=>^|~]'
    return synID(a:lnum, a:col, 1) == g:ruby#indent#operator
  elseif a:char ==# '\'
    return synID(a:lnum, a:col, 1) == g:ruby#indent#backslash
  endif
endfunction

function s:is_hanging_keyword_operator(char, line, lnum, col)
  if a:char ==# "d"
    if a:line[a:col - 4 : a:col - 2] =~# '\<an$'
      return synID(a:lnum, a:col - 2, 1) == g:ruby#indent#keyword
    endif
  elseif a:char ==# "r"
    if a:line[a:col - 3 : a:col - 2] =~# '\<o$'
      return synID(a:lnum, a:col - 1, 1) == g:ruby#indent#keyword
    endif
  elseif a:char ==# "t"
    if a:line[a:col - 4 : a:col - 2] =~# '\<no$'
      return synID(a:lnum, a:col - 2, 1) == g:ruby#indent#keyword
    endif
  endif
endfunction

function s:is_hanging_bracket(char, lnum, col)
  if a:char =~# '[([{|]'
    return synID(a:lnum, a:col, 1) == g:ruby#indent#delimiter
  endif
endfunction

function s:is_hanging_comma(char, lnum, col)
  if a:char ==# ","
    return synID(a:lnum, a:col, 1) == g:ruby#indent#comma
  endif
endfunction

function s:get_last_char(lnum, line)
  " First, try to find a comment delimiter: if one is found, the
  " non-whitespace character immediately before it is the last
  " character; else, simply find the last non-whitespace character in
  " the line.
  let found = -1

  while 1
    let found = stridx(a:line, "#", found + 1)

    if found == -1
      let [char, pos, _] = matchstrpos(a:line, '\S\ze\s*$')
      return [char, pos]
    elseif found == 0
      return ["", -1]
    endif

    if synID(a:lnum, found + 1, 1) == g:ruby#indent#comment
      break
    endif
  endwhile

  let [char, pos, _] = matchstrpos(a:line[:found - 1], '\S\ze\s*$')
  return [char, pos]
endfunction

function s:find_floating_index(lnum, i, j)
  call cursor(a:lnum, a:j + 1)

  let pairs = 0
  let [_, col, p] = searchpos(s:floating_re, "bcp", a:lnum)

  while col >= a:i + 1
    if p == 2  " begin case for if unless until while
      if synID(a:lnum, col, 1) == g:ruby#indent#keyword
        if pairs == 0
          return col - 1
        else
          let pairs += 1
        endif
      endif
    elseif p == 3  " else elsif ensure in rescue when
      if pairs == 0
        let synid = synID(a:lnum, col, 1)

        if synid == g:ruby#indent#keyword || synid == g:ruby#indent#block_control || synid == g:ruby#indent#define_block_control
          return a:i
        endif
      endif
    elseif p == 4  " class def module
      if synID(a:lnum, col, 1) == g:ruby#indent#define
        if pairs == 0
          return a:i
        else
          let pairs += 1
        endif
      endif
    elseif p == 5  " do
      if synID(a:lnum, col, 1) == g:ruby#indent#keyword
        if pairs == 0
          return a:i
        else
          let pairs += 1
        endif
      endif
    elseif p == 6  " end
      let synid = synID(a:lnum, col, 1)

      if synid == g:ruby#indent#keyword || synid == g:ruby#indent#define
        let pairs -= 1
      endif
    elseif p == 7  " ( [ {
      if synID(a:lnum, col, 1) == g:ruby#indent#delimiter
        if pairs == 0
          let [_, col2] = searchpos('\S', "z", a:lnum)

          if col2
            return col2 - 1
          else
            return a:i
          endif
        else
          let pairs += 1
        endif
      endif
    elseif p == 8  " ) ] }
      if synID(a:lnum, col, 1) == g:ruby#indent#delimiter
        let pairs -= 1
      endif
    elseif p == 9  " |
      if pairs == 0
        if synID(a:lnum, col, 1) == g:ruby#indent#delimiter
          return a:i
        endif
      endif
    endif

    let [_, col, p] = searchpos(s:floating_re, "bp", a:lnum)
  endwhile

  return -1
endfunction

function s:find_msl(skip_commas, pairs)
  let [lnum, col] = searchpos('\S', "czW")
  let prev_lnum = prevnonblank(lnum - 1)

  if prev_lnum == 0
    return [lnum, col - 1, 0]
  endif

  " This line is *not* the MSL if:

  " It is part of a multiline region.
  let synid = synID(lnum, 1, 1)

  if synid == g:ruby#indent#comment || get(g:ruby#indent#multiline_regions, synid)
    call cursor(prev_lnum, 1)
    return s:find_msl(a:skip_commas, v:null)
  endif

  " It starts with `=end`.
  let line = getline(lnum)

  if line =~# '^=end\>'
    let lnum = search('^=begin\>', "bWz")

    while synID(lnum, 1, 1) != g:ruby#indent#comment
      let lnum = search('^=begin\>', "bWz")
    endwhile

    let prev_lnum = prevnonblank(lnum - 1)
    call cursor(prev_lnum, 1)
    return s:find_msl(a:skip_commas, v:null)
  endif

  " It starts with a leading dot.
  if match(line, '^\.\.\@!', col - 1) != -1
    call cursor(prev_lnum, 1)
    return s:find_msl(a:skip_commas, v:null)
  endif

  " It contains a positive number of unpaired closing brackets or
  " keywords; find the corresponding starting line...
  "
  " *unless* the line starts with an `end` that is part of a definition.
  if a:pairs is v:null
    let pairs = 0

    if match(line, '^end:\@!\>', col - 1) != -1
      if col == 1
        return [lnum, col - 1, 0]
      endif

      if synID(lnum, col, 1) == g:ruby#indent#define
        return [lnum, col - 1, 0]
      endif

      let pairs = -1

      call cursor(0, col + 3)
    endif

    let [_, col2, p] = searchpos(s:pair_re, "czp", lnum)

    while p
      let synid = synID(lnum, col2, 1)

      if p == 2  " def class module
        if synid == g:ruby#indent#define
          let pairs += 1
        endif
      elseif p == 3  " if unless case while until for begin do
        if synid == g:ruby#indent#keyword
          let pairs += 1
        endif
      elseif p == 4  " else rescue ensure
        if pairs == 0
          if synid == g:ruby#indent#block_control || synid == g:ruby#indent#define_block_control
            let pairs += 1
          endif
        endif
      elseif p == 5  " elsif when in
        if pairs == 0
          if synid == g:ruby#indent#keyword
            let pairs += 1
          endif
        endif
      elseif p == 6  " end
        if synid == g:ruby#indent#define || synid == g:ruby#indent#keyword
          let pairs -= 1
        endif
      elseif p == 7  " ( [ {
        if synid == g:ruby#indent#delimiter
          let pairs += 1
        endif
      elseif p == 8  " ) ] }
        if synid == g:ruby#indent#delimiter
          let pairs -= 1
        endif
      endif

      let [_, col2, p] = searchpos(s:pair_re, "zp", lnum)
    endwhile

    if pairs < 0
      call cursor(0, 1)

      while pairs < 0
        let lnum = searchpair(s:start_pair_re, "", s:end_pair_re, "bW", s:skip_pair_expr)
        let pairs += 1
      endwhile

      let pairs += searchpair(s:start_pair_re, "", s:end_pair_re, "bmr", s:skip_pair_expr, lnum)

      call cursor(0, 1)
      return s:find_msl(a:skip_commas, pairs)
    endif
  else
    let pairs = a:pairs
  endif

  " The previous line ends with a comma, backslash, or hanging operator.
  let prev_line = getline(prev_lnum)
  let [last_char, last_idx] = s:get_last_char(prev_lnum, prev_line)

  if last_idx != -1
    if s:is_hanging_comma(last_char, prev_lnum, last_idx + 1)
      if !a:skip_commas
        call cursor(prev_lnum, 1)
        return s:find_msl(0, v:null)
      endif
    elseif s:is_hanging_operator(last_char, prev_lnum, last_idx + 1) || s:is_hanging_keyword_operator(last_char, prev_line, prev_lnum, last_idx + 1)
      call cursor(prev_lnum, 1)
      return s:find_msl(a:skip_commas, v:null)
    endif
  endif

  " Else, this line is the MSL.
  return [lnum, col - 1, pairs > 0]
endfunction
" }}}

" GetRubyIndent {{{
if get(g:, "ruby_simple_indent")
  " Simple {{{
  function GetRubyIndent() abort
    " If the current line is inside of a multiline region, do nothing.
    let synid = synID(v:lnum, 1, 1)

    if get(g:ruby#indent#multiline_regions, synid)
      return -1
    endif

    " Special case for the above:
    "
    " If the current line is inside of a multiline comment, check to see
    " if it begins with `=end`.
    if synid == g:ruby#indent#comment
      if getline(v:lnum) =~# '^\s*=end\>'
        return 0
      else
        return -1
      endif
    endif

    let prev_lnum = prevnonblank(v:lnum - 1)

    if prev_lnum == 0
      return 0
    endif

    " Retrieve indentation info for the previous line.
    let prev_line = getline(prev_lnum)

    if prev_line =~# '^=end\>'
      call cursor(prev_lnum, 1)

      let lnum = search('^=begin\>', "bWz")

      while synID(lnum, 1, 1) != g:ruby#indent#comment
        let lnum = search('^=begin\>', "bWz")
      endwhile

      let prev_lnum = prevnonblank(lnum - 1)
      let prev_line = getline(prev_lnum)
    endif

    let [last_char, last_idx] = s:get_last_char(prev_lnum, prev_line)

    " This variable tells whether or not the previous line is
    " a continuation of another line.
    " 0 -> no continuation
    " 1 -> continuation caused by a backslash or hanging operator
    " 2 -> continuation caused by a comma (list continuation)
    " 3 -> continuation caused by an opening bracket
    let continuation = 0

    if last_idx != -1
      " If the previous line begins in a multiline region, find the line
      " that began that region.

      if get(g:ruby#indent#multiline_regions, synID(prev_lnum, 1, 1))
        let start_lnum = s:prev_non_multiline(prevnonblank(prev_lnum - 1))
        let start_line = getline(start_lnum)
      else
        let start_lnum = prev_lnum
        let start_line = prev_line
      endif

      " Find the first column and first character of the line.
      let [first_char, first_idx, _] = matchstrpos(start_line, '\S')

      " Determine whether or not the line is a continuation.
      if first_char ==# "."
        if start_line[first_idx + 1] !=# "."
          let continuation = 1
        endif
      elseif first_char !~# '[)\]}]'
        let lnum = prevnonblank(start_lnum - 1)

        if lnum
          let line = getline(lnum)
          let [char, idx] = s:get_last_char(lnum, line)

          if idx != -1
            if s:is_hanging_operator(char, lnum, idx + 1) || s:is_hanging_keyword_operator(char, line, lnum, idx + 1)
              let continuation = 1
            elseif s:is_hanging_comma(char, lnum, idx + 1)
              let continuation = 2
            elseif s:is_hanging_bracket(char, lnum, idx + 1)
              let continuation = 3
            endif
          endif
        endif
      endif
    else
      " The previous line is a comment line.
      let first_idx = stridx(prev_line, "#")
      let start_lnum = prev_lnum
      let start_line = prev_line
    endif

    " Find the first character in the current line.
    let line = getline(v:lnum)

    let [char, idx, _] = matchstrpos(line, '\S')

    if char ==# "."
      " If the current line begins with a leading dot, add a shift unless
      " the previous line was a line continuation.

      if line[idx + 1] !=# "."
        if continuation == 1
          return first_idx
        else
          return first_idx + shiftwidth()
        endif
      endif
    elseif char ==# ")"
      " If the current line begins with a closing bracket, subtract
      " a shift unless the previous character was the corresponding
      " bracket; subtract an additional shift if the previous line was
      " a continuation.

      let shift = 1

      if last_char ==# "(" && synID(prev_lnum, last_idx + 1, 1) == g:ruby#indent#delimiter
        let shift = 0
      endif

      if continuation == 1
        let shift += 1
      endif

      return first_idx - shift * shiftwidth()
    elseif char ==# "]"
      let shift = 1

      if last_char ==# "[" && synID(prev_lnum, last_idx + 1, 1) == g:ruby#indent#delimiter
        let shift = 0
      endif

      if continuation == 1
        let shift += 1
      endif

      return first_idx - shift * shiftwidth()
    elseif char ==# "}"
      let shift = 1

      if (last_char ==# "{" || last_char ==# "|") && synID(prev_lnum, last_idx + 1, 1) == g:ruby#indent#delimiter
        let shift = 0
      endif

      if continuation == 1
        let shift += 1
      endif

      return first_idx - shift * shiftwidth()
    elseif char ==# "="
      if match(line, '^\%(begin\|end\)\>', idx + 1) != -1
        return 0
      endif
    elseif match(line, '\v^%(end|else|elsif|when|in|rescue|ensure):@!>', idx) != -1
      let shift = 1

      if continuation == 1
        let shift += 1
      endif

      if searchpair(s:kw_start_re, s:kw_middle_re, s:kw_end_re, "b", s:skip_keyword_expr, start_lnum)
        let shift -= 1
      endif

      return first_idx - shift * shiftwidth()
    endif

    " If we can't determine the indent from the current line, examine the
    " previous line.

    if last_idx == -1
      return first_idx
    endif

    if s:is_hanging_comma(last_char, prev_lnum, last_idx + 1)
      " If the last character was a comma, add a shift unless:
      "
      " The previous line begins with a closing bracket or `end`.
      "
      " The line before the starting line ended with a comma or
      " a hanging bracket.

      if prev_lnum == start_lnum
        if first_char =~# '[)\]}]'
          return first_idx
        elseif match(start_line, '^end:\@!\>', first_idx) != -1
          return first_idx
        endif
      endif

      if continuation == 1
        return first_idx - shiftwidth()
      elseif continuation == 2 || continuation == 3
        return first_idx
      else
        return first_idx + shiftwidth()
      endif
    elseif s:is_hanging_bracket(last_char, prev_lnum, last_idx + 1) || s:is_hanging_operator(last_char, prev_lnum, last_idx + 1) || s:is_hanging_keyword_operator(last_char, prev_line, prev_lnum, last_idx + 1)
      if continuation == 1
        return first_idx
      else
        return first_idx + shiftwidth()
      endif
    endif

    if searchpair(s:kw_start_re, s:kw_middle_re, s:kw_end_re, "b", s:skip_keyword_expr, start_lnum)
      let shift = 1
    elseif continuation == 1 || continuation == 2
      let shift = -1
    else
      let shift = 0
    endif

    return first_idx + shift * shiftwidth()
  endfunction
  " }}}
else
  " Default {{{
  function GetRubyIndent() abort
    " If the current line is inside of a multiline region, do nothing.
    let synid = synID(v:lnum, 1, 1)

    if get(g:ruby#indent#multiline_regions, synid)
      return -1
    endif

    " Special case for the above:
    "
    " If the current line is inside of a multiline comment, check to see
    " if it begins with `=end`.
    if synid == g:ruby#indent#comment
      if getline(v:lnum) =~# '^\s*=end\>'
        return 0
      else
        return -1
      endif
    endif

    let prev_lnum = prevnonblank(v:lnum - 1)

    if prev_lnum == 0
      return 0
    endif

    " Retrieve indentation info for the previous line.
    let prev_line = getline(prev_lnum)

    if prev_line =~# '^=end\>'
      call cursor(prev_lnum, 1)

      let [lnum, col] = searchpos('^=begin\>', "bWz")

      while synID(lnum, col, 1) != g:ruby#indent#comment
        let [lnum, col] = searchpos('^=begin\>', "bWz")
      endwhile

      let prev_lnum = prevnonblank(lnum - 1)
      let prev_line = getline(prev_lnum)
    endif

    let [last_char, last_idx] = s:get_last_char(prev_lnum, prev_line)

    " Before we proceed, we need to determine which column we will use
    " as the starting position.
    "
    " If there is a floating column somehwere in the previous line, that
    " is the starting column.
    "
    " Else, the first column of the previous line is the starting
    " position.

    if last_idx == -1
      " The previous line was a comment line.
      let first_idx = stridx(prev_line, "#")
      let floating_idx = -1
      let start_idx = first_idx
    else
      let first_idx = match(prev_line, '\S')
      let floating_idx = s:find_floating_index(prev_lnum, first_idx, last_idx)
      let start_idx = floating_idx != -1 ? floating_idx : first_idx

      " Check the last character of the previous line.
      if s:is_hanging_operator(last_char, prev_lnum, last_idx + 1)
        " If the previous line ends with a hanging operator or
        " backslash...

        " Find the next previous line.
        let prev_prev_lnum = prevnonblank(prev_lnum - 1)

        if prev_prev_lnum
          let prev_prev_line = getline(prev_prev_lnum)
          let [prev_last_char, prev_last_idx] = s:get_last_char(prev_prev_lnum, prev_prev_line)

          " If the next previous line also ends with a hanging operator or
          " backslash...
          if s:is_hanging_operator(prev_last_char, prev_prev_lnum, prev_last_idx + 1)
            " Align with the starting column.
            return start_idx
          endif
        endif

        " If the first character in the previous line is part of
        " a keyword, align with the first non-operator character after
        " that word.
        let [_, _, offset] = matchstrpos(prev_line, '\v^%(case|elsif|if|in|unless|until|when|while):@!>', start_idx)

        if offset != -1
          return match(prev_line, '\S', offset + 1)
        endif

        " Otherwise, align with the first character after the first
        " assignment operator in the line, if one can be found.
        "
        " NOTE: Make sure to skip bracketed groups.
        call cursor(prev_lnum, start_idx + 1)

        let pairs = 0
        let [_, col, p] = searchpos('\([([{]\)\|\([)\]}]\)\|\([=!]\@1<!=[=>~]\@!\)', "cpz", prev_lnum)

        while p
          if p == 2
            if synID(prev_lnum, col, 1) == g:ruby#indent#delimiter
              let pairs += 1
            endif
          elseif p == 3
            if pairs > 0 && synID(prev_lnum, col, 1) == g:ruby#indent#delimiter
              let pairs -= 1
            endif
          elseif p == 4
            if pairs == 0 && synID(prev_lnum, col, 1) == g:ruby#indent#operator
              let idx = match(prev_line, '\S', col)

              if idx != -1
                return idx
              endif
            endif
          endif

          let [_, col, p] = searchpos('\([([{]\)\|\([)\]}]\)\|\([=!]\@1<!=[=>~]\@!\)', "pz", prev_lnum)
        endwhile

        " Otherwise, simply align with the starting position and add
        " a shift.
        return start_idx + shiftwidth()
      elseif s:is_hanging_comma(last_char, prev_lnum, last_idx + 1)
        " If the previous line ends with a comma...

        " First, find the MSL of the previous line.
        call cursor(prev_lnum, 1)
        let [msl, ind, _] = s:find_msl(1, v:null)

        " Find the line prior to the MSL.
        let prev_prev_lnum = prevnonblank(msl - 1)

        if prev_prev_lnum
          let prev_prev_line = getline(prev_prev_lnum)
          let [prev_last_char, prev_last_idx] = s:get_last_char(prev_prev_lnum, prev_prev_line)

          if s:is_hanging_comma(prev_last_char, prev_prev_lnum, prev_last_idx + 1) || s:is_hanging_bracket(prev_last_char, prev_prev_lnum, prev_last_idx + 1)
            " If the next previous line also ended with a comma or an
            " opening bracket, align with the MSL, unless the current line
            " begins with a closing bracket.
            if getline(v:lnum) =~# '^\s*[)\]}]'
              return ind - shiftwidth()
            endif

            return ind
          elseif s:is_hanging_operator(prev_last_char, prev_prev_lnum, prev_last_idx + 1)
            " If the next previous line ended with a backslash or hanging
            " operator, align with the MSL.
            return ind
          endif
        endif

        " Else, align with the previous line and add a shift.
        if floating_idx != -1
          return floating_idx
        else
          return first_idx + shiftwidth()
        endif
      elseif s:is_hanging_bracket(last_char, prev_lnum, last_idx + 1)
        " If the previous line ends with an opening bracket, align with
        " the starting column and add a shift unless the current line
        " begins with a closing bracket or `end`.
        if getline(v:lnum) =~# '^\s*\%([)\]}]\|end:\@!\>\)'
          return start_idx
        else
          return start_idx + shiftwidth()
        endif
      elseif s:is_hanging_keyword_operator(last_char, prev_line, prev_lnum, last_idx + 1)
        " If the previous line ends with a keyword operator (`and`, `or`,
        " `not`), align with the starting column; add a shift unless the
        " next previous line also ended with a keyword operator.
        let prev_prev_lnum = prevnonblank(prev_lnum - 1)

        if prev_prev_lnum
          let prev_prev_line = getline(prev_prev_lnum)
          let [prev_last_char, prev_last_idx] = s:get_last_char(prev_prev_lnum, prev_prev_line)

          if s:is_hanging_keyword_operator(prev_last_char, prev_prev_line, prev_prev_lnum, prev_last_idx + 1)
            return start_idx
          endif
        endif

        return start_idx + shiftwidth()
      endif
    endif

    " Next, examine the first character of the current line.
    let line = getline(v:lnum)
    let [char, idx, _] = matchstrpos(line, '\S')

    if char ==# "."
      " If the current line starts with a leading dot:
      "
      " Align with the first leading dot in the previous line, if any.
      "
      " Else, add a shift.
      if line[idx + 1] !=# "."
        let idx = match(prev_line, '\.\.\@!', first_idx)

        if idx != -1
          return idx
        else
          return start_idx + shiftwidth()
        endif
      endif
    elseif char =~# '[)\]}]'
      " If the current line begins with a closing bracket, subtract
      " a shift.
      if floating_idx != -1
        return floating_idx
      else
        call cursor(prev_lnum, 1)
        let [_, ind, _] = s:find_msl(1, v:null)
        return ind - shiftwidth()
      endif
    elseif char ==# "="
      if match(line, '^\%(begin\|end\)\>', idx + 1) != -1
        return 0
      endif
    elseif match(line, '\v^%(end|else|elsif|when|in|rescue|ensure):@!>', idx) != -1
      if floating_idx != -1
        return floating_idx
      else
        call cursor(prev_lnum, 1)
        let [_, ind, shift] = s:find_msl(0, v:null)
        return ind + (shift - 1) * shiftwidth()
      endif
    endif

    if floating_idx != -1
      return floating_idx + shiftwidth()
    else
      call cursor(prev_lnum, 1)
      let [_, ind, shift] = s:find_msl(0, v:null)

      if shift
        let ind += shiftwidth()
      endif

      return ind
    endif
  endfunction
  " }}}
endif
" }}}

" vim:fdm=marker
