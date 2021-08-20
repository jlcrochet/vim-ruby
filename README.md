## Introduction

This is intended to be a drop-in replacement for [vim-ruby](https://github.com/vim-ruby/vim-ruby). The reason I wrote it is because the original vim-ruby is known for having many accuracy and performance issues related to syntax highlighting and indentation. After perusing the code for the original plugin, I decided that a complete rewrite was necessary.

In addition to regular Ruby files (`*.rb`), this plugin also supports eRuby (`*.erb`) and [Ruby Signature](https://github.com/ruby/rbs) (`*.rbs`) files.

## Configuration

#### `g:ruby_simple_indent`

The default indentation style used by this plugin is the one most commonly found in the Ruby community, which allows for "hanging" or "floating" indentation. Some examples:

``` ruby
x = if y
      5
    else
      10
    end

x = begin
      h["foo"]
    rescue KeyError
      "Not Found"
    end

x = case y
    when :foo
      5
    when :bar
      10
    else
      1
    end

x = [:foo, :bar,
     :baz, :qux]

x = 5 + 10 +
    15 + 20 -
    5 * 3

x = y.foo
     .bar
     .baz
```

For those who prefer a more traditional indentation style or who desire slightly faster highlighting and indentation, set `g:ruby_simple_indent` to `1`. The above examples will now be indented thus:

``` ruby
x = if y
  5
else
  10
end

x = begin
  h["foo"]
rescue KeyError
  "Not Found"
end

x = case y
when :foo
  5
when :bar
  10
else
  1
end

x = [:foo, :bar,
  :baz, :qux]

# OR

x = [
  :foo, :bar,
  :baz, :qux
]

x = 5 + 10 +
  15 + 20 -
  5 * 3

# OR

x =
  5 + 10 +
  15 + 20 -
  5 * 3

x = y.foo
  .bar
  .baz

# OR

x = y
  .foo
  .bar
  .baz
```

#### `g:ruby_fold`

If `1`, definition blocks (`module`, `class`, `def`) will be folded.

NOTE: If this is set, `g:ruby_simple_indent` will be disabled, since floating blocks have to be matched in order for folding to work properly.

#### `g:eruby_extensions`

A dictionary of filetype extensions is used to determine which filetype to use when loading ERB files. For example, opening a file named `foo.html.erb` will load HTML as the filetype with ERB syntax added on top.

The default recognized extensions are as follows:

```
.html => html
.js => javascript
.json => json
.xml => xml
.yml => yaml
.txt => text
.md => markdown
```

Each extension maps to the name of the filetype that you want to load for that extension.

To add or overwrite entries in the dictionary, set `g:eruby_extensions` to a dictinoary with the entries that you want to inject. For example, the following would allow the plugin to recognize `*.js` files as JSX instead of JavaScript:

``` vim
let g:eruby_extensions = { "js": "javascriptreact" }
```

If no subtype is specified in the file name itself (e.g., `foo.erb`), the value of `g:eruby_default_subtype` is used as the subtype.

#### `g:eruby_default_subtype`

Determines the default subtype to use for ERB files when no subtype is specified in the file name itself (e.g., `foo.erb`).

The default value is `html`. Setting this to nothing (`let g:eruby_default_subtype = ""`) will cause no subtype to be used.

## Performance Comparison with [vim-ruby](https://github.com/vim-ruby/vim-ruby)

Comparisons made between the respective HEAD's of each plugin as of this writing (2021-4-29) using [this test file](https://gist.github.com/jlcrochet/baf507ffc4be93e9074a99f39a79ec8e). I'm currently running NeoVim 0.5.0.

### Syntax

Benchmark:

``` vim
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
```

The general idea is to go to the top of the file, redraw the viewport, page down (<kbd>Ctrl</kbd>+<kbd>D</kbd>), and repeat until the end of the file has been reached. This is done fifteen times, after which we get the cumulative results from `syntime report`. It's kinda rough, but it works.

Results on my machine:

```
vim-ruby/vim-ruby:

4.51s

jlcrochet/vim-ruby:

0.62s
0.47s  (g:ruby_simple_indent = 1)
```

### Indentation

Benchmark:

``` vim
command! IndentBenchmark
      \ goto |
      \ let start = reltime() |
      \ call feedkeys("=G", "x") |
      \ echo reltimestr(reltime(start)) |
      \ unlet start
```

Again, a pretty rough test, but it gets the job done.

Results:

```
vim-ruby/vim-ruby:

10.13s

jlcrochet/vim-ruby (VimL):

1.39s
0.72s  (g:ruby_simple_indent = 1)

jlcrochet/vim-ruby (Lua):

0.32s
0.16s  (g:ruby_simple_indent = 1)
```
