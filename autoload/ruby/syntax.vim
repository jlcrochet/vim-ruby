" Vim autoload file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

function s:choice(...)
  return '\%('.join(a:000, '\|').'\)'
endfunction

" Number patterns:
let s:exponent_suffix = '[eE][+-]\=\d\+\%(_\d\+\)*i\='
let s:fraction = '\.\d\+\%(_\d\+\)*' . s:choice(s:exponent_suffix, 'r\=i\=')

let s:nonzero_re = '[1-9]\d*\%(_\d\+\)*' . s:choice(
      \ s:exponent_suffix,
      \ s:fraction,
      \ 'r\=i\=',
      \ )

let s:zero_re = '0' . s:choice(
      \ s:exponent_suffix,
      \ s:fraction,
      \ '\o\+\%(_\o\+\)*',
      \ '[bB][01]\+\%(_[01]\+\)*r\=i\=',
      \ '[oO]\o\+\%(_\o\+\)*r\=i\=',
      \ '[dD]\d\+\%(_\d\+\)*r\=i\=',
      \ '[xX]\x\+\%(_\x\+\)*r\=i\=',
      \ ) . '\='

let s:syn_match_template = 'syn match rubyNumber /\%%#=1%s/ nextgroup=@rubyPostfix skipwhite'

const g:ruby#syntax#numbers = printf(s:syn_match_template, s:nonzero_re) . " | " . printf(s:syn_match_template, s:zero_re)

" This pattern matches all operators that can be used as methods; these
" are also the only operators that can be referenced as symbols.
const g:ruby#syntax#overloadable_operators = s:choice(
      \ '[&|^/%]',
      \ '=\%(==\=\|\~\)',
      \ '>[=>]\=',
      \ '<\%(<\|=>\=\)\=',
      \ '[+\-~]@\=',
      \ '\*\*\=',
      \ '\[]=\=',
      \ '![@=~]\='
      \ )

" Onigmo groups and references are kinda complicated, so we're defining
" the patterns here:
let s:onigmo_escape = '\\' . s:choice(
      \ '\d\+',
      \ 'x\%(\x\x\|{\x\+}\)',
      \ 'u\x\x\x\x',
      \ 'c.',
      \ 'C-.',
      \ 'M-\%(\\C-.\|.\)',
      \ 'p{\^\=\h\w*}',
      \ 'P{\h\w*}',
      \ 'k' . s:choice('<\%(\h\w*\|-\=\d\+\)\%([+-]\d\+\)\=>', '''\%(\h\w*\|-\=\d\+\)\%([+-]\d\+\)\='''),
      \ 'g' . s:choice('<\%(\h\w*\|-\=\d\+\)>', '''\%(\h\w*\|-\=\d\+\)'''),
      \ '.'
      \ )

const g:ruby#syntax#onigmo_escape = printf(
      \ 'syn match rubyOnigmoEscape /\%%#=1%s/ contained',
      \ s:onigmo_escape
      \ )

let s:onigmo_group_modifier = "?" . s:choice(
      \ '[imxdau]\+\%(-[imx]\+\)\=:\=',
      \ '[:=!>~]',
      \ '<[=!]',
      \ '<\h\w*>',
      \ "(" . s:choice('\d\+', '<\h\w*>', '''\h\w*''') . ")"
      \ )

const g:ruby#syntax#onigmo_group = printf(
      \ 'syn region rubyOnigmoGroup matchgroup=rubyOnigmoMetaCharacter start=/\%%#=1(\%%(%s\)\=/ end=/\%%#=1)/ contained transparent',
      \ s:onigmo_group_modifier
      \ )

unlet
      \ s:exponent_suffix s:fraction s:nonzero_re s:zero_re s:syn_match_template
      \ s:onigmo_escape s:onigmo_group_modifier

delfunction s:choice
