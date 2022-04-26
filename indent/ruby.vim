" Vim indent file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@hey.com>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, "did_indent")
  finish
endif

let b:did_indent = 1

setlocal indentkeys=0),0],0},0.,0=..,0=&.,o,O,!^F
let &indentkeys ..= "," .. g:ruby#indent#dedent_words

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
let s:multiline_regions = #{
      \ rubyComment: 1,
      \ rubyString: 1,
      \ rubyStringEscape: 1,
      \ rubyStringInterpolationDelimiter: 1,
      \ rubyStringParenthesisEscape: 1,
      \ rubyStringSquareBracketEscape: 1,
      \ rubyStringCurlyBraceEscape: 1,
      \ rubyStringAngleBracketEscape: 1,
      \ rubyStringEnd: 1,
      \ rubyArrayEscape: 1,
      \ rubySymbol: 1,
      \ rubySymbolEnd: 1,
      \ rubyRegex: 1,
      \ rubyRegexEnd: 1,
      \ rubyRegexSlashEscape: 1,
      \ rubyOnigmoEscape: 1,
      \ rubyOnigmoGroup: 1,
      \ rubyOnigmoMetaCharacter: 1,
      \ rubyOnigmoQuantifier: 1,
      \ rubyOnigmoComment: 1,
      \ rubyOnigmoClass: 1,
      \ rubyOnigmoPOSIXClass: 1,
      \ rubyOnigmoIntersection: 1,
      \ rubyCommand: 1,
      \ rubyCommandEnd: 1,
      \ rubyHeredocLine: 1,
      \ rubyHeredocLineRaw: 1,
      \ rubyHeredocEnd: 1
      \ }

let s:block_start_re = '\C\v<%(if|unless|case|begin|for|while|until|do)>'
let s:block_middle_re = '\C\v<%(else|elsif|when|ensure|in|rescue)>'

let s:define_block_start_re = '\C\v<%(def|class|module)>'
let s:define_block_middle_re = '\C\v<%(else|ensure|rescue)>'

let s:all_start_re = '\C\v<%(if|unless|case|begin|for|while|until|do|def|class|module)>'

let s:skip_bracket = 'synID(line("."), col("."), 0)->synIDattr("name") !~# ''^ruby\%(StringArray\|SymbolArray\)\=Delimiter$'''
let s:skip_keyword = 'synID(line("."), col("."), 0)->synIDattr("name") !=# "rubyKeyword"'
let s:skip_define = 'synID(line("."), col("."), 0)->synIDattr("name") !=# "rubyDefine"'
let s:skip_all = 'synID(line("."), col("."), 0)->synIDattr("name") !~# ''^ruby\%(Keyword\|Define\)$'''

function s:skip_keyword_simple_func()
  let [l, c] = [line("."), col(".")]

  if synID(l, c, 0)->synIDattr("name") !=# "rubyKeyword"
    return 1
  endif

  if expand("<cword>") ==# "def"
    " Check for an "endless" definition:
    let [l, c] = searchpos('=[=>~]\@!', "z", l)

    while l
      if synID(l, c, 0)->synIDattr("name") ==# "rubyMethodAssignmentOperator"
        return 1
      endif

      let [l, c] = searchpos('=[=>~]\@!', "z", l)
    endwhile
  endif
endfunction

let s:skip_keyword_simple = function("s:skip_keyword_simple_func")

function s:is_operator(char, idx, lnum)
  if a:char =~# '[%&*+\-/:<>?^|~]'
    return synID(a:lnum, a:idx + 1, 0)->synIDattr("name") ==# "rubyOperator"
  elseif a:char ==# "="
    return synID(a:lnum, a:idx + 1, 0)->synIDattr("name") =~# '^ruby\%(MethodAssignment\)\=Operator$'
  endif
endfunction

" 0 = no continuation
" 1 = hanging operator or backslash
" 2 = hanging postfix keyword
" 3 = comma
" 4 = opening bracket
" 5 = hash key delimiter
function s:ends_with_line_continuator(lnum)
  let line = getline(a:lnum)
  let [char, idx, next_idx] = line->matchstrpos('\S')

  let last_idx = idx

  while idx != -1
    if char ==# "#"
      if synID(a:lnum, next_idx, 0)->synIDattr("name") ==# "rubyLineComment"
        break
      endif
    else
      let [word, _, offset] = line->matchstrpos('^\l\+', idx)

      if offset != -1
        let next_idx = offset
      endif
    endif

    let last_idx = idx

    let [char, idx, next_idx] = line->matchstrpos('\S', next_idx)
  endwhile

  let last_char = line[last_idx]

  if last_char ==# '\'
    if synID(a:lnum, last_idx + 1, 0)->synIDattr("name") ==# "rubyBackslash"
      return 1
    endif
  elseif last_char ==# ","
    if synID(a:lnum, last_idx + 1, 0)->synIDattr("name") ==# "rubyComma"
      return 3
    endif
  elseif last_char ==# ":"
    let syngroup = synID(a:lnum, last_idx + 1, 0)->synIDattr("name")

    if syngroup ==# "rubyOperator"
      return 1
    elseif syngroup ==# "rubySymbolStart"
      return 5
    endif
  elseif last_char ==# "(" || last_char ==# "[" || last_char ==# "{"
    if synID(a:lnum, last_idx + 1, 0)->synIDattr("name") =~# '^ruby\%(StringArray\|SymbolArray\)\=Delimiter$'
      return 4
    endif
  elseif last_char ==# "|"
    let syngroup = synID(a:lnum, last_idx + 1, 0)->synIDattr("name")

    if syngroup ==# "rubyOperator"
      return 1
    elseif syngroup ==# "rubyDelimiter"
      return 4
    endif
  elseif last_char ==# "a"
    if line->match('\C^and[[:alnum:]_?!:]\@!', last_idx) != -1
      return 2
    endif
  elseif last_char ==# "i"
    if line->match('\C^i[fn][[:alnum:]_?!:]\@!', last_idx) != -1
      return 2
    endif
  elseif last_char ==# "n"
    if line->match('\C^not[[:alnum:]_?!:]\@!', last_idx) != -1
      return 2
    endif
  elseif last_char ==# "o"
    if line->match('\C^or[[:alnum:]_?!:]\@!', last_idx) != -1
      return 2
    endif
  elseif last_char ==# "r"
    if line->match('\C^rescue[[:alnum:]_?!:]\@!', last_idx) != -1 && synID(a:lnum, last_idx + 1, 0)->synIDattr("name") ==# "rubyPostfixKeyword"
      return 2
    endif
  elseif last_char ==# "u"
    if line->match('\C^un\%(less\|til\)[[:alnum:]_?!:]\@!', last_idx) != -1
      return 2
    endif
  elseif last_char ==# "w"
    if line->match('\C^while[[:alnum:]_?!:]\@!', last_idx) != -1
      return 2
    endif
  elseif s:is_operator(last_char, last_idx, a:lnum)
    return 1
  endif
endfunction

function s:get_msl(lnum)
  let prev_lnum = prevnonblank(a:lnum - 1)

  if prev_lnum == 0
    return a:lnum
  endif

  let start_lnum = prev_lnum

  while s:multiline_regions->get(synID(start_lnum, 1, 0)->synIDattr("name"))
    let start_lnum = prevnonblank(start_lnum - 1)
  endwhile

  let continuation = 0

  let start_line = getline(start_lnum)
  let [start_first_char, start_first_idx, start_first_col] = start_line->matchstrpos('\S')

  if start_first_char ==# "&"
    if start_line[start_first_col] ==# "."
      let continuation = 6
    endif
  elseif start_first_char ==# "."
    if start_line[start_first_col] !=# "."
      let continuation = 6
    endif
  endif

  let prev_lnum = prevnonblank(start_lnum - 1)

  if prev_lnum == 0
    return start_lnum
  endif

  if !continuation
    let continuation = s:ends_with_line_continuator(prev_lnum)

    if continuation == 4
      return start_lnum
    endif
  endif

  while continuation
    let start_lnum = prev_lnum

    while s:multiline_regions->get(synID(start_lnum, 1, 0)->synIDattr("name"))
      let start_lnum = prevnonblank(start_lnum - 1)
    endwhile

    let continuation = 0

    let start_line = getline(start_lnum)
    let [start_first_char, start_first_idx, start_first_col] = start_line->matchstrpos('\S')

    if start_first_char ==# "&"
      if start_line[start_first_col] ==# "."
        let continuation = 6
      endif
    elseif start_first_char ==# "."
      if start_line[start_first_col] !=# "."
        let continuation = 6
      endif
    endif

    let prev_lnum = prevnonblank(start_lnum - 1)

    if prev_lnum == 0
      return start_lnum
    endif

    if !continuation
      let continuation = s:ends_with_line_continuator(prev_lnum)

      if continuation == 4
        return start_lnum
      endif
    endif
  endwhile

  return start_lnum
endfunction
" }}}

if get(g:, "ruby_simple_indent")
  " Simple {{{
  function GetRubyIndent() abort
    let syngroup = synID(v:lnum, 1, 0)->synIDattr("name")

    if syngroup ==# "rubyComment"
      " Check to see if this line is the `=end` of a block comment:
      if getline(v:lnum) =~# '^\s*=end\>'
        return 0
      else
        return -1
      endif
    endif

    if s:multiline_regions->get(syngroup)
      return -1
    endif

    let prev_lnum = prevnonblank(v:lnum - 1)

    if prev_lnum == 0
      return 0
    endif

    " Check the current line for a closing bracket or dedenting keyword:
    let line = getline(v:lnum)
    let [first_char, first_idx, first_col] = line->matchstrpos('\S')

    if line->match('\C^=begin\>', first_idx) != -1
      return 0
    endif

    let shift = 0
    let has_dedent = 0
    let continuation = 0

    if first_char ==# ")" || first_char ==# "]" || first_char ==# "}"
      let shift -= 1
      let has_dedent = 1
    elseif first_char ==# "&"
      if line[first_col] ==# "."
        let continuation = 6
      endif
    elseif first_char ==# "."
      if line[first_col] !=# "."
        let continuation = 6
      endif
    elseif line->match('\C^\%(end\|else\|elsif\|when\|in\|rescue\|ensure\)[[:alnum:]_?!:]\@!', first_idx) != -1
      let shift -= 1
      let has_dedent = 1
    endif

    " Check the previous line:
    let start_lnum = prev_lnum

    while s:multiline_regions->get(synID(start_lnum, 1, 0)->synIDattr("name"))
      let start_lnum = prevnonblank(start_lnum - 1)
    endwhile

    if !continuation
      let continuation = s:ends_with_line_continuator(prev_lnum)

      if continuation == 4
        let shift += 1
        return indent(start_lnum) + shift * shiftwidth()
      endif
    endif

    call cursor(0, 1)

    if searchpair(s:all_start_re, s:block_middle_re, '\C\<end\>', "b", s:skip_keyword_simple, start_lnum)
      let shift += 1
      return indent(start_lnum) + shift * shiftwidth()
    endif

    " Check for line continuations:
    let prev_continuation = 0

    let start_line = getline(start_lnum)
    let [start_first_char, start_first_idx, start_first_col] = start_line->matchstrpos('\S')

    if start_first_char ==# "&"
      if start_line[start_first_col] ==# "."
        let prev_continuation = 6
      endif
    elseif start_first_char ==# "."
      if start_line[start_first_col] !=# "."
        let prev_continuation = 6
      endif
    endif

    if !prev_continuation
      let prev_lnum = prevnonblank(start_lnum - 1)

      if prev_lnum != 0
        let prev_continuation = s:ends_with_line_continuator(prev_lnum)
      endif
    endif

    if continuation == 0
      if prev_continuation == 1 || prev_continuation == 2 || prev_continuation == 6
        let shift -= 1
      elseif prev_continuation == 3
        if !has_dedent && start_line->match('\C^\%([)\]}]\|end[[:alnum:]_?!:]\@!\)', start_first_idx) == -1
          let shift -= 1
        endif
      endif
    elseif continuation == 1 || continuation == 2 || continuation == 6
      if prev_continuation == 1 || prev_continuation == 2 || prev_continuation == 5 || prev_continuation == 6
        return start_first_idx
      else
        return start_first_idx + shiftwidth()
      endif
    elseif continuation == 3
      if prev_continuation == 1 || prev_continuation == 2
        let shift -= 1
      elseif prev_continuation == 3
        if has_dedent
          return start_first_idx - shiftwidth()
        else
          return start_first_idx
        endif
      elseif prev_continuation == 4
        return start_first_idx
      elseif prev_continuation == 5
        return start_first_idx - shiftwidth()
      else
        if start_line->match('\C^\%([)\]}]\|end[[:alnum:]_?!:]\@!\)', start_first_idx) == -1
          return start_first_idx + shiftwidth()
        endif
      endif
    elseif continuation == 5
      return start_first_idx + shiftwidth()
    endif

    " Default:
    return start_first_idx + shift * shiftwidth()
  endfunction
  " }}}
else
  " Default {{{
  function GetRubyIndent() abort
    let syngroup = synID(v:lnum, 1, 0)->synIDattr("name")

    if syngroup ==# "rubyComment"
      " Check to see if this line is the `=end` of a block comment:
      if getline(v:lnum) =~# '^\s*=end\>'
        return 0
      else
        return -1
      endif
    endif

    if s:multiline_regions->get(syngroup)
      return -1
    endif

    let prev_lnum = prevnonblank(v:lnum - 1)

    if prev_lnum == 0
      return 0
    endif

    " Check the current line for a closing bracket or dedenting keyword:
    let line = getline(v:lnum)
    let [first_char, first_idx, first_col] = line->matchstrpos('\S')

    if line->match('\C^=begin\>', first_idx) != -1
      return 0
    endif

    call cursor(0, 1)

    if first_char ==# ")"
      return indent(searchpair('(', '', ')', "bW", s:skip_bracket))
    elseif first_char ==# "]"
      return indent(searchpair('\[', '', ']', "bW", s:skip_bracket))
    elseif first_char ==# "}"
      return indent(searchpair('{', '', '}', "bW", s:skip_bracket))
    elseif line->match('\C^\%(end\|else\|elsif\|when\|in\|rescue\|ensure\)[[:alnum:]_?!:]\@!', first_idx) != -1
      let syngroup = synID(v:lnum, first_col, 0)->synIDattr("name")

      if syngroup ==# "rubyKeyword"
        let [l, c] = searchpairpos(s:block_start_re, s:block_middle_re, '\C\<end\>', "bW", s:skip_keyword)

        if expand("<cword>") ==# "do"
          return indent(l)
        else
          return c - 1
        endif
      elseif syngroup ==# "rubyDefine"
        let shift = -1
        let msl = s:get_msl(v:lnum)

        if searchpair(s:define_block_start_re, s:define_block_middle_re, '\C\<end\>', "b", s:skip_define, msl)
          let shift += 1
        endif

        return indent(msl) + shift * shiftwidth()
      endif
    endif

    " Check the previous line:
    let start_lnum = prev_lnum

    while s:multiline_regions->get(synID(start_lnum, 1, 0)->synIDattr("name"))
      let start_lnum = prevnonblank(start_lnum - 1)
    endwhile

    let [l, c, p] = searchpos('\C\([(\[{]\)\|\([)\]}]\)\|\v<%((def|class|module)|(if|unless|case|begin|while|until|for|do)|(else|elsif|when|in|ensure|rescue)|(end))>', "bp", start_lnum)

    while p
      let syngroup = synID(l, c, 0)->synIDattr("name")

      if p == 2
        if syngroup ==# "rubyDelimiter"
          let line = getline(l)
          let [char, idx, _] = line->matchstrpos('\S', c)

          if char ==# "|" || char ==# "#"
            return indent(l) + shiftwidth()
          else
            return idx
          endif
        elseif syngroup ==# "rubyStringArrayDelimiter" || syngroup ==# "rubySymbolArrayDelimiter"
          if search('\S', "z", l)
            return col(".") - 1
          else
            return indent(l) + shiftwidth()
          endif
        endif
      elseif p == 3
        if syngroup ==# "rubyDelimiter" || syngroup ==# "rubyStringArrayDelimiter" || syngroup ==# "rubySymbolArrayDelimiter"
          let start_lnum = searchpair('[(\[{]', '', '[)\]}]', "bW", s:skip_bracket)

          while s:multiline_regions->get(synID(start_lnum, 1, 0)->synIDattr("name"))
            let start_lnum = prevnonblank(start_lnum - 1)
          endwhile
        endif
      elseif p == 4
        if syngroup ==# "rubyDefine"
          return indent(l) + shiftwidth()
        endif
      elseif p == 5
        if syngroup ==# "rubyKeyword"
          if expand("<cword>") ==# "do"
            return indent(l) + shiftwidth()
          else
            return c - 1 + shiftwidth()
          endif
        endif
      elseif p == 6
        if syngroup ==# "rubyKeyword" || syngroup ==# "rubyDefine"
          return c - 1 + shiftwidth()
        endif
      elseif p == 7
        if syngroup ==# "rubyKeyword"
          let start_lnum = searchpair(s:block_start_re, '', '\C\<end\>', "bW", s:skip_keyword)

          while s:multiline_regions->get(synID(start_lnum, 1, 0)->synIDattr("name"))
            let start_lnum = prevnonblank(start_lnum - 1)
          endwhile
        elseif syngroup ==# "rubyDefine"
          let start_lnum = searchpair(s:define_block_start_re, '', '\C\<end\>', "bW", s:skip_define)

          while s:multiline_regions->get(synID(start_lnum, 1, 0)->synIDattr("name"))
            let start_lnum = prevnonblank(start_lnum - 1)
          endwhile
        endif
      endif

      let [l, c, p] = searchpos('\C\([(\[{]\)\|\([)\]}]\)\|\v<%((def|class|module)|(if|unless|case|begin|while|until|for|do)|(else|elsif|when|in|ensure|rescue)|(end))>', "bp", start_lnum)
    endwhile

    " Check for line continuations:
    " 0 = no continuation
    " 1 = hanging operator or backslash
    " 2 = hanging postfix keyword
    " 3 = comma
    " 4 = opening bracket
    " 5 = hash key delimiter
    " 6 = leading dot
    let continuation = 0

    if first_char ==# "&"
      if line[first_col] ==# "."
        let continuation = 6
      endif
    elseif first_char ==# "."
      if line[first_col] !=# "."
        let continuation = 6
      endif
    endif

    if !continuation
      let continuation = s:ends_with_line_continuator(prev_lnum)
    endif

    let prev_continuation = 0

    let start_line = getline(start_lnum)
    let [start_first_char, start_first_idx, start_first_col] = start_line->matchstrpos('\S')

    if start_first_char ==# "&"
      if start_line[start_first_col] ==# "."
        let prev_continuation = 6
      endif
    elseif start_first_char ==# "."
      if start_line[start_first_col] !=# "."
        let prev_continuation = 6
      endif
    endif

    if !prev_continuation
      let prev_prev_lnum = prevnonblank(start_lnum - 1)

      if prev_prev_lnum > 0
        let prev_continuation = s:ends_with_line_continuator(prev_prev_lnum)
      endif
    endif

    if continuation == 0
      if prev_continuation == 1 || prev_continuation == 3 || prev_continuation == 6
        return indent(s:get_msl(start_lnum))
      elseif prev_continuation == 2
        return start_first_idx - shiftwidth()
      endif
    elseif continuation == 1
      if prev_continuation == 1 || prev_continuation == 5
        return start_first_idx
      else
        " Align with the first character after the first operator in the
        " starting line, if any:
        let upper = strlen(start_line) - 1

        for i in range(start_first_idx + 1, upper)
          let char = start_line[i]

          if char ==# " " || char ==# "\t"
            continue
          endif

          if s:is_operator(char, i, start_lnum)
            for j in range(i + 1, upper)
              let char = start_line[j]

              if char ==# " " || char ==# "\t"
                continue
              endif

              if !s:is_operator(char, j, start_lnum)
                return j
              endif
            endfor

            break
          endif
        endfor

        return start_first_idx + shiftwidth()
      endif
    elseif continuation == 2
      if prev_continuation == 1 || prev_continuation == 2 || prev_continuation == 5
        return start_first_idx
      else
        return start_first_idx + shiftwidth()
      endif
    elseif continuation == 3
      if prev_continuation == 1
        return indent(s:get_msl(start_lnum))
      elseif prev_continuation == 2 || prev_continuation == 5
        return start_first_idx - shiftwidth()
      elseif prev_continuation == 3 || prev_continuation == 4
        return start_first_idx
      else
        return start_first_idx + shiftwidth()
      endif
    elseif continuation == 5
      return start_first_idx + shiftwidth()
    elseif continuation == 6
      if prev_continuation == 6
        return start_first_idx
      else
        " Align with the first dot in the starting line, if any:
        let idx = stridx(start_line, ".", start_first_idx + 1)

        while idx != -1
          if synID(start_lnum, idx + 1, 0)->synIDattr("name") ==# "rubyMethodOperator"
            if start_line[idx - 1] ==# "&"
              return idx - 1
            else
              return idx
            endif
          endif

          let idx = stridx(start_line, ".", idx + 2)
        endwhile

        return start_first_idx + shiftwidth()
      endif
    endif

    " Default:
    return start_first_idx
  endfunction
  " }}}
endif

" vim:fdm=marker
