## Introduction

This is intended to be a replacement for [vim-ruby](https://github.com/vim-ruby/vim-ruby) for people who are willing to sacrifice some of the aforementioned plugin's features and customization for superior performance.

The reason I wrote this plugin is because the original vim-ruby is known for having many performance issues related to syntax highlighting and indentation.

After installation, you can check out `test.rb` for a variety of cases -- mostly pulled from the [Ruby Reference](https://rubyreferences.github.io/rubyref/) -- that this plugin is able to handle.

The only notable edge case I've found that this plugin can't handle at the moment is highlighting nested heredocs, such as the following:

    puts(<<-ONE, <<-TWO)
    content for heredoc one
    ONE
    content for heredoc two
    TWO

I may come up with a solution for this someday, but it seems to be an extremely rare use case anyway.

## Configuration

For `%`-style literals, this plugin only provides the following delimiters by default: `()`, `[]`, `{}`, and `<>`. This is because covering the entire range of possible delimiters -- which includes ```~`!@#$%^&*_-+=|\:;"',.?/``` -- is expensive and most of them are never used.

If you want access to the full set of delimiters, you can set `g:ruby_extended_delimiters` to `1` in your vimrc or elsewhere.

## Performance Comparison with [vim-ruby](https://github.com/vim-ruby/vim-ruby)

Comparisons made between the respective HEAD's of each plugin as of this writing (2020-11-17), using `test.rb` as the test file:

### Syntax

Benchmark:

    command! SyntaxBenchmark
          \ syntime clear |
          \ syntime on |
          \ let last_lnum = line("$") |
          \ for _ in range(15) |
          \ goto |
          \ while line(".") < last_lnum |
          \ redraw |
          \ execute "normal! \<c-d>" |
          \ endwhile |
          \ endfor |
          \ syntime off |
          \ syntime report |
          \ unlet last_lnum

The general idea is to go to the top of the file, redraw the viewport, page down (<kbd>Ctrl</kbd>+<kbd>D</kbd>), and repeat until the end of the file has been reached. This is done fifteen times, after which we get the cumulative results from `syntime report`. It's kinda rough, but it works.

Results on my machine:

    vim-ruby/vim-ruby:

    2.24s
    2.10s  (g:ruby_no_expensive = 1)

    jlcrochet/vim-ruby:

    0.18s
    0.32s  (g:ruby_extended_delimiters = 1)

### Indentation

Benchmark:

    command! IndentBenchmark
          \ let start = reltime() |
          \ for _ in range(15) |
          \ call feedkeys("ggVG=", "x") |
          \ endfor |
          \ echo reltimestr(reltime(start)) |
          \ unlet start

Again, a pretty rough test, but it gets the job done.

Results:

    vim-ruby/vim-ruby:

    12.82s
    29.68s  (g:ruby_no_expensive = 1) (?!)

    jlcrochet/vim-ruby (VimL):

    5.40s
    6.29s  (g:ruby_extended_delimiters = 1)

    jlcrochet/vim-ruby (Lua):

    1.88s
    2.73s  (g:ruby_extended_delimiters = 1)

Not only is the original vim-ruby much slower (especially with `g:ruby_no_expensive = 1`; not sure why), but there are also numerous cases in `test.rb` that it doesn't indent properly.

## TODO

* ERB
* Folding
