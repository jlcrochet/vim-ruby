# vim-ruby

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

## TODO

* ERB
* Folding
