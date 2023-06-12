" Vim indent file
" Language: HAML
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if get(b:, "did_indent")
  finish
endif

if !exists("*GetHamlIndent")
  let s:indentexprs = {}

  if get(g:, "haml_filter_css", 1)
    runtime indent/css.vim indent/css.lua | unlet! b:did_indent

    if &indentexpr !=# ""
      let s:indentexprs.hamlFilter_css = &indentexpr
      setlocal indentexpr<
    else
      let s:indentexprs.hamlFilter_css = "-1"
    endif
  endif

  if get(g:, "haml_filter_erb", 0)
    runtime indent/eruby.vim indent/eruby.lua | unlet! b:did_indent

    if &indentexpr !=# ""
      let s:indentexprs.hamlFilter_erb = &indentexpr
      setlocal indentexpr<
    else
      let s:indentexprs.hamlFilter_erb = "-1"
    endif
  endif

  if get(g:, "haml_filter_javascript", 1)
    runtime indent/javascript.vim indent/javascript.lua | unlet! b:did_indent

    if &indentexpr !=# ""
      let s:indentexprs.hamlFilter_javascript = &indentexpr
      setlocal indentexpr<
    else
      let s:indentexprs.hamlFilter_javascript = "-1"
    endif
  endif

  if get(g:, "haml_filter_less", 0)
    runtime indent/less.vim indent/less.lua | unlet! b:did_indent

    if &indentexpr !=# ""
      let s:indentexprs.hamlFilter_less = &indentexpr
      setlocal indentexpr<
    else
      let s:indentexprs.hamlFilter_less = "-1"
    endif
  endif

  if get(g:, "haml_filter_markdown", 0)
    runtime indent/markdown.vim indent/markdown.lua | unlet! b:did_indent

    if &indentexpr !=# ""
      let s:indentexprs.hamlFilter_markdown = &indentexpr
      setlocal indentexpr<
    else
      let s:indentexprs.hamlFilter_markdown = "-1"
    endif
  endif

  if get(g:, "haml_filter_ruby", 1)
    runtime indent/ruby.vim indent/ruby.lua | unlet! b:did_indent
    let s:indentexprs.hamlFilter_ruby = &indentexpr
    setlocal indentexpr<
  endif

  if get(g:, "haml_filter_sass", 0)
    runtime indent/sass.vim indent/sass.lua | unlet! b:did_indent

    if &indentexpr !=# ""
      let s:indentexprs.hamlFilter_sass = &indentexpr
      setlocal indentexpr<
    else
      let s:indentexprs.hamlFilter_sass = "-1"
    endif
  endif

  if get(g:, "haml_filter_scss", 0)
    runtime indent/scss.vim indent/scss.lua | unlet! b:did_indent

    if &indentexpr !=# ""
      let s:indentexprs.hamlFilter_scss = &indentexpr
      setlocal indentexpr<
    else
      let s:indentexprs.hamlFilter_scss = "-1"
    endif
  endif

  if exists("g:haml_custom_filters")
    for [s:name, s:filetype] in items(g:haml_custom_filters)
      execute printf(
          \ "runtime indent/%s.vim indent/%s.lua",
          \ s:filetype, s:filetype
          \ )

      unlet! b:did_indent

      if &indentexpr !=# ""
        let s:indentexprs["hamlFilter_"..s:name] = &indentexpr
        setlocal indentexpr<
      else
        let s:indentexprs["hamlFilter_"..s:name] = "-1"
      endif
    endfor
  endif

  let s:skip_brackets = 'synID(line("."), col("."), 0)->synIDattr("name") !=# "hamlDelimiter"'

  let s:haml_ruby_start = '^\s*\%(-\|[&!]\=[=~]\)'

  function s:default(prev_indent)
    let curr_indent = indent(v:lnum)

    if curr_indent > a:prev_indent
      return a:prev_indent
    else
      return curr_indent
    endif
  endfunction

  function s:default_with_optional_indent(prev_indent)
    let curr_indent = indent(v:lnum)

    if curr_indent - a:prev_indent > &shiftwidth
      return a:prev_indent + &shiftwidth
    else
      return curr_indent
    endif
  endfunction

  function GetHamlIndent() abort
    let prev_lnum = prevnonblank(v:lnum - 1)

    if prev_lnum == 0
      return 0
    endif

    let stack = synstack(v:lnum, 1)

    if len(stack)
      let inner = stack[-1]->synIDattr("name")

      if inner ==# "hamlComment"
        return -1
      elseif inner !=# "hamlFilterStart"
        let outer = stack[0]->synIDattr("name")

        if outer ==# "hamlRubyLine"
          if getline(prev_lnum) =~# s:haml_ruby_start
            return indent(prev_lnum) + 2 + &shiftwidth
          else
            return indent(prev_lnum)
          endif
        elseif outer ==# "hamlAttributes" || outer ==# "hamlAttributeHash" || outer ==# "hamlObjectReference"
          let shift = 0

          let [last_char, last_idx, last_col] = getline(prev_lnum)->matchstrpos('\S\ze\s*$')

          if last_char ==# "(" || last_char ==# "[" || last_char ==# "{"
            let syngroup = synID(prev_lnum, last_col, 0)->synIDattr("name")

            if syngroup ==# "hamlDelimiter" || syngroup ==# "rubyDelimiter"
              let shift += 1
            endif
          endif

          if getline(v:lnum) =~# '^\s*[)\]}]'
            let shift -= 1
          endif

          return indent(prev_lnum) + shift * &shiftwidth
        elseif outer ==# "hamlFilter"
          return -1
        elseif s:indentexprs->has_key(outer)
          if synID(prev_lnum, 1, 0)->synIDattr("name") ==# "hamlFilterStart"
            return indent(prev_lnum) + &shiftwidth
          else
            let result = eval(s:indentexprs[outer])

            if result == 0
              return indent(prev_lnum)
            else
              return result
            endif
          endif
        endif
      endif
    endif

    let syngroup = synID(prev_lnum, 1, 0)->synIDattr("name")

    if syngroup ==# "hamlRubyLine"
      let prev_indent = indent(prev_lnum) - 2 - &shiftwidth
      return s:default(prev_indent)
    elseif syngroup ==# "hamlComment"
      call cursor(prev_lnum, 1)

      let [l, c] = searchpos('^\s*-#\s*$', "zbW")

      while synID(l, c, 0)->synIDattr("name") !=# "hamlCommentStart"
        let [l, c] = searchpos('^\s*-#\s*$', "zbW")
      endwhile

      return s:default(c - 1)
    elseif syngroup ==# "hamlFilterDefault" || (syngroup !=# "" && syngroup[:3] !=# "haml")
      call cursor(prev_lnum, 1)

      let [l, c] = searchpos('^\s*:', "zbW")

      while synID(l, c, 0)->synIDattr("name") !=# "hamlFilterStart"
        let [l, c] = searchpos('^\s*:', "zbW")
      endwhile

      return s:default(c - 1)
    endif

    let prev_line = getline(prev_lnum)
    let [char, idx, off] = prev_line->matchstrpos('\S')
    let ind = idx

    if getline(v:lnum) =~# '^\s*-\s*\%(when\|in\|els\%(e\|if\)\)\>'
      let ind -= &shiftwidth
    endif

    if char ==# "-"
      if prev_line[off] ==# "#"
        return s:default(ind)
      endif

      let [word, _, off] = prev_line->matchstrpos('^\s*\zs\w\+', off)

      if word =~# '\v<%(for|while|until|else|if|els%(e|if)|case|when|in)>'
        return ind + &shiftwidth
      endif

      let off = prev_line->matchend('\<do\>', off)

      while off != -1
        let syngroup = synID(prev_lnum, off - 1, 0)->synIDattr("name")

        if syngroup ==# "rubyKeyword"
          return ind + &shiftwidth
        elseif syngroup ==# "rubyLineComment"
          break
        endif

        let off = prev_line->matchend('\<do\>', off)
      endwhile
    elseif char ==# "/"
      let new_off = prev_line->matchend('^!\=\[.\{-}]', off)

      if new_off != -1
        let off = new_off
      endif

      if prev_line->match('\S', off) == -1
        return s:default_with_optional_indent(ind)
      else
        return s:default(ind)
      endif
    elseif char ==# ":"
      return ind + &shiftwidth
    elseif char ==# "%" || char == "#" || char ==# "."
      let off = prev_line->matchend('\%(%\a[^[:space:]/<>([{&!=]*\)\=\%([#.][^[:space:]%#./<>([{&!=~]\+\)*', idx)

      if off != -1
        while prev_line[off] =~# '[([{]' && synID(prev_lnum, off + 1, 0)->synIDattr("name") ==# "hamlDelimiter"
          call cursor(prev_lnum, off + 1)
          let [_, off] = searchpairpos('[([{]', '', '[)\]}]', "z", s:skip_brackets, prev_lnum)
        endwhile

        let new_off = prev_line->matchend('^\%(<>\=\|><\=\)', off)

        if new_off != -1
          let off = new_off
        endif

        if prev_line->match('\S', off) == -1
          return s:default_with_optional_indent(ind)
        endif
      else
        return s:default_with_optional_indent(ind)
      endif
    endif

    return s:default(ind)
  endfunction
endif

setlocal
    \ indentkeys+=0.,0..,=elsif,=when,=else,=in
    \ indentexpr=GetHamlIndent()

let b:did_indent = 1
