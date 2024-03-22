## Introduction

This is intended to be a drop-in replacement for [vim-ruby](https://github.com/vim-ruby/vim-ruby). I wrote it because the original vim-ruby is known for having many accuracy and performance issues related to syntax highlighting and indentation. After perusing the code for the original plugin, I decided that a complete rewrite was necessary.

In addition to regular Ruby files, this plugin also supports editing ERB and HAML files. If you want support for Ruby Signature files, check out my [vim-rbs](https://github.com/jlcrochet/vim-rbs) plugin.

## Installation

This is a standard Vim plugin which can be installed using your plugin manager of choice. If you do not already have a plugin manager, I recommend [vim-plug](https://github.com/junegunn/vim-plug).

## Configuration

### Ruby

#### `g:ruby_simple_indent`

* Type: boolean
* Default: `0`

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

### HAML

The following variables enable syntax highlighting and indentation for code inside of HAML filters.

NOTE: These variables cause syntax files for other file types to be loaded, which may increase load times or degrade performance; additionally, the code in said files were not necessarily written by the author of this plugin and are thus not guaranteed to work well with this plugin.

#### `g:haml_filter_css`

* Type: boolean
* Default: `1`

Enables highlighting and indentation for code inside of `:css` filters.

#### `g:haml_filter_erb`

* Type: boolean
* Default: `0`

Enables highlighting and indentation for code inside of `:erb` filters.

#### `g:haml_filter_javascript`

* Type: boolean
* Default: `1`

Enables highlighting and indentation for code inside of `:javascript` filters.

#### `g:haml_filter_less`

* Type: boolean
* Default: `0`

Enables highlighting and indentation for code inside of `:less` filters.

#### `g:haml_filter_markdown`

* Type: boolean
* Default: `0`

Enables highlighting and indentation for code inside of `:markdown` filters.

#### `g:haml_filter_ruby`

* Type: boolean
* Default: `1`

Enables highlighting and indentation for code inside of `:ruby` filters.

#### `g:haml_filter_sass`

* Type: boolean
* Default: `0`

Enables highlighting and indentation for code inside of `:sass` filters.

#### `g:haml_filter_scss`

* Type: boolean
* Default: `0`

Enables highlighting and indentation for code inside of `:scss` filters.

#### `g:haml_custom_filters`

* Type: dictionary

This dictionary can be used to add highlighting and indentation for custom filters. Each key is the name of a filter that you want to provide syntax for and the corresponding value is the name of the Vim file type to load. For example:

``` vim
let g:haml_custom_filters = #{
    \ coffee: "coffeescript",
    \ custom_ruby: "ruby"
    \ }
```

The first entry in the above allows text inside of `:coffee` filters to be highlighted and indented as CoffeeScript, assuming that you have a syntax plugin installed that defines a `coffeescript` file type. The second entry allows text inside of a hypothetical custom filter named `:custom_ruby` to be highlighted and indented as Ruby.
