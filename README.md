## Introduction

This is intended to be a drop-in replacement for [vim-ruby](https://github.com/vim-ruby/vim-ruby). I wrote it because the original vim-ruby is known for having many accuracy and performance issues related to syntax highlighting and indentation. After perusing the code for the original plugin, I decided that a complete rewrite was necessary.

In addition to regular Ruby files (`*.rb`), this plugin also supports eRuby (`*.erb`) and [Ruby Signature](https://github.com/ruby/rbs) (`*.rbs`) files.

## Installation

This is a standard Vim plugin which can be installed using your plugin manager of choice. If you do not already have a plugin manager, I recommend [vim-plug](https://github.com/junegunn/vim-plug).

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

#### `g:eruby_extensions`

A dictionary of filetype extensions is used to determine which filetype to use when loading ERB files. For example, opening a file named `foo.html.erb` will load HTML as the filetype with ERB syntax added on top.

The default recognized extensions are as follows:

```
.html => html
.turbo_stream => html
.js => javascript
.json => json
.xml => xml
.yml => yaml
.txt => text
.md => markdown
```

Each extension maps to the name of the filetype that you want to load for that extension.

To add or overwrite entries in the dictionary, set `g:eruby_extensions` to a dictionary with the entries that you want to inject. For example, the following would allow the plugin to recognize `*.js` files as JSX instead of JavaScript:

``` vim
let g:eruby_extensions = { "js": "javascriptreact" }
```

If no subtype is specified in the file name itself (e.g., `foo.erb`), the value of `g:eruby_default_subtype` is used as the subtype.

#### `g:eruby_default_subtype`

Determines the default subtype to use for ERB files when no subtype is specified in the file name itself (e.g., `foo.erb`).

The default value is `html`. Setting this to nothing (`let g:eruby_default_subtype = ""`) will cause no subtype to be used.
