" Vim syntax file
" Language: HAML
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = "haml"
endif

let b:is_haml = 1

syn include @hamlruby syntax/ruby.vim | unlet! b:current_syntax

syn match hamlSOL /\%#=1^/ nextgroup=hamlRubyStart,hamlTagStart,hamlIdStart,hamlClassStart,hamlCommentTagStart,hamlLineComment,hamlDoctype skipwhite

syn match hamlRubyStart /\%#=1\%(-\|[&!]\=[=~]\)/ contained nextgroup=hamlRubyLine
syn match hamlRubyLine /\%#=1\%(,\_s*\|.\)*/ contained contains=@hamlruby

syn match hamlTagStart /\%#=1%/ contained nextgroup=hamlTag
syn match hamlTag /\%#=1\a[^[:space:]%#./<>([{&!=~]*/ contained nextgroup=hamlRubyStart,hamlIdStart,hamlClassStart,hamlTagModifier,hamlAttributes,hamlAttributeHash,hamlObjectReference

syn match hamlIdStart /\%#=1#/ contained nextgroup=hamlId
syn match hamlId /\%#=1[^[:space:]%#./<>([{&!=~]\+/ contained nextgroup=hamlRubyStart,hamlClassStart,hamlTagModifier,hamlAttributes,hamlAttributeHash,hamlObjectReference

syn match hamlClassStart /\%#=1\./ contained nextgroup=hamlClass
syn match hamlClass /\%#=1[^[:space:]%#./<>([{&!=~]\+/ contained nextgroup=hamlRubyStart,hamlIdStart,hamlClassStart,hamlTagModifier,hamlAttributes,hamlAttributeHash,hamlObjectReference

syn match hamlTagModifier /\%#=1\%(\/\|<>\=\/\=\|><\=\/\=\)/ contained nextgroup=hamlRubyStart

syn region hamlAttributes matchgroup=hamlDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=hamlAttribute,rubyNestedParentheses nextgroup=hamlAttributeHash,hamlObjectReference,hamlTagModifier,hamlRubyStart
syn match hamlAttribute /\%#=1[^>/=)[:space:]]\+/ contained nextgroup=hamlAttributeAssignmentOperator skipwhite
syn match hamlAttributeAssignmentOperator /\%#=1=/ contained nextgroup=@rubyRHS skipwhite

syn region hamlAttributeHash matchgroup=hamlDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@rubyRHS,rubyHashKey,rubyDelimiter,rubyNestedBraces,rubyComment,rubyLineComment nextgroup=hamlAttributes,hamlObjectReference,hamlTagModifier,hamlRubyStart

syn region hamlObjectReference matchgroup=hamlDelimiter start=/\%#=1\[/ end=/\%#=1]/ contained contains=@rubyRHS,rubyNestedBrackets nextgroup=hamlAttributes,hamlAttributeHash,hamlTagModifier,hamlRubyStart

syn match hamlCommentTagStart /\%#=1\/\%(!\=\[.\{-}]\)\=/ contained nextgroup=hamlRubyStart

syn match hamlLineComment /\%#=1-#.*/ contained contains=hamlTodo
syn region hamlComment matchgroup=hamlCommentStart start=/\%#=1^\z(\s*\)-#\s*$/ end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=hamlTodo
syn keyword hamlTodo BUG DEPRECATED FIXME NOTE WARNING OPTIMIZE TODO XXX TBD contained

syn region hamlFilter matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):\w\+/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ keepend

syn cluster hamlInterpolationRegions contains=hamlFilter

if get(g:, "haml_filter_css", 1)
  syn include @hamlcss syntax/css.vim | unlet! b:current_syntax
  syn region hamlFilter_css matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):css\>/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=@hamlcss keepend
  syn cluster hamlInterpolationRegions add=hamlFilter_css,css\w*
endif

if get(g:, "haml_filter_erb", 0)
  syn include @hamleruby syntax/eruby.vim | unlet! b:current_syntax
  syn region hamlFilter_erb matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):erb\>/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=@hamleruby keepend
  syn cluster hamlInterpolationRegions add=hamlFilter_erb,eruby\w*
endif

if get(g:, "haml_filter_javascript", 1)
  syn include @hamljavascript syntax/javascript.vim | unlet! b:current_syntax
  syn region hamlFilter_javascript matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):javascript\>/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=@hamljavascript keepend
  syn cluster hamlInterpolationRegions add=hamlFilter_javascript,javascript\w*
endif

if get(g:, "haml_filter_less", 0)
  syn include @hamlless syntax/less.vim | unlet! b:current_syntax
  syn region hamlFilter_less matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):less\>/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=@hamlless keepend
  syn cluster hamlInterpolationRegions add=hamlFilter_less,less\w*
endif

if get(g:, "haml_filter_markdown", 0)
  syn include @hamlmarkdown syntax/markdown.vim | unlet! b:current_syntax
  syn region hamlFilter_markdown matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):markdown\>/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=@hamlmarkdown keepend
  syn cluster hamlInterpolationRegions add=hamlFilter_markdown,markdown\w*
endif

if get(g:, "haml_filter_ruby", 1)
  syn region hamlFilter_ruby matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):ruby\>/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=@hamlruby keepend
  syn cluster hamlInterpolationRegions add=hamlFilter_ruby
endif

if get(g:, "haml_filter_sass", 0)
  syn include @hamlsass syntax/sass.vim | unlet! b:current_syntax
  syn region hamlFilter_sass matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):sass\>/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=@hamlsass keepend
  syn cluster hamlInterpolationRegions add=hamlFilter_sass,sass\w*
endif

if get(g:, "haml_filter_scss", 0)
  syn include @hamlscss syntax/scss.vim | unlet! b:current_syntax
  syn region hamlFilter_scss matchgroup=hamlFilterStart start=/\%#=1^\z(\s*\):scss\>/ matchgroup=NONE end=/\%#=1^\%(\z1\s\)\@!/ skip=/\%#=1^\s*$/ contains=@hamlscss keepend
  syn cluster hamlInterpolationRegions add=hamlFilter_scss,scss\w*
endif

if exists("g:haml_custom_filters")
  let s:filetypes = #{
      \ ruby: 1
      \ }

  for [s:name, s:filetype] in items(g:haml_custom_filters)
    execute printf(
        \ 'syn region hamlFilter_%s matchgroup=hamlFilterStart start=/\%%#=1^\z(\s*\):%s\>/ matchgroup=NONE end=/\%%#=1^\%%(\z1\s\)\@!/ skip=/\%%#=1^\s*$/ contains=@haml%s',
        \ s:name, s:name, s:filetype
        \ )
    execute printf(
        \ 'syn cluster hamlInterpolationRegions add=hamlFilter_%s',
        \ s:name
        \ )

    if !s:filetypes->get(s:filetype)
      execute printf(
          \ 'syn include @haml%s syntax/%s.vim | unlet! b:current_syntax | syn cluster hamlInterpolationRegions add=%s\w*',
          \ s:filetype, s:filetype, s:filetype
          \ )

      let s:filetypes[s:filetype] = 1
    endif
  endfor
endif

syn match hamlDoctype /\%#=1!!!.*/ contained

syn match hamlEscape /\%#=1\\[/\\%#.=&!\-~]/ containedin=@hamlInterpolationRegions

syn region hamlInterpolation matchgroup=rubyStringInterpolationDelimiter start=/\%#=1#{/ end=/\%#=1}/ contains=@rubyRHS,rubyNestedBraces containedin=@hamlInterpolationRegions
syn match hamlInterpolation /\%#=1#\%(@@\=[^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|\$\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|[!@~&`'"+=/\\,;:.<>_*$?]\|-\w\|0\|[1-9]\d*\)\)/ contains=rubyStringInterpolationDelimiter,rubyInstanceVariable,rubyGlobalVariable containedin=@hamlInterpolationRegions

syn sync fromstart

let b:current_syntax = "haml"

" Highlighting
hi def link hamlComment Comment
hi def link hamlEscape PreProc
hi def link hamlRubyStart PreProc
hi def link hamlAttribute Keyword
hi def link hamlAttributeAssignmentOperator Operator
hi def link hamlDelimiter PreProc
hi def link hamlLineComment hamlComment
hi def link hamlDoctype PreProc
hi def link hamlTodo Todo
hi def link hamlCommentTagStart PreProc
hi def link hamlTagStart PreProc
hi def link hamlTag Identifier
hi def link hamlIdStart PreProc
hi def link hamlId Special
hi def link hamlClassStart PreProc
hi def link hamlClass Special
hi def link hamlTagModifier PreProc
hi def link hamlFilterStart PreProc
hi def link hamlCommentStart hamlComment
