#!/usr/bin/env ruby

1234
1_234
12.34
1234e-2
1.234E1

0d170
0D170

0xaa
0xAa
0xAA
0Xaa
0XAa
0XaA

0252
0o252
0O252

0b10101010
0B10101010

12r         #=> (12/1)
12.3r       #=> (123/10)

0.1r + 0.2r #=> (3/10)
0.1 + 0.2   #=> 0.30000000000000004

1i          #=> (0+1i)
1i * 1i     #=> (-1+0i)

12.3ri      #=> (0+(123/10)*i)

"This is a string."

"This string has a quote: \".  As you can see, it is escaped"

"\a"             # bell, ASCII 07h (BEL)
"\b"             # backspace, ASCII 08h (BS)
"\t"             # horizontal tab, ASCII 09h (TAB)
"\n"             # newline (line feed), ASCII 0Ah (LF)
"\v"             # vertical tab, ASCII 0Bh (VT)
"\f"             # form feed, ASCII 0Ch (FF)
"\r"             # carriage return, ASCII 0Dh (CR)
"\e"             # escape, ASCII 1Bh (ESC)
"\s"             # space, ASCII 20h (SPC)
"\\"             # backslash, \
"\123"           # octal bit pattern, where nnn is 1-3 octal digits ([0-7])
"\x1f"           # hexadecimal bit pattern, where nn is 1-2 hexadecimal digits ([0-9a-fA-F])
"\u12af"         # Unicode character, where nnnn is exactly 4 hexadecimal digits ([0-9a-fA-F])
"\u{1af2 FFFF}"  # Unicode character(s), where each nnnn is 1-6 hexadecimal digits ([0-9a-fA-F])
"\cx" or "\C-x"  # control character, where x is an ASCII printable character
"\M-x"           # meta character, where x is an ASCII printable character
"\M-\C-x"        # meta control character, where x is an ASCII printable character
"\M-\cx"         # same as above
"\c\M-x"         # same as above
"\c?" or "\C-?"  # delete, ASCII 7Fh (DEL)

"One plus one is two: #{1 + 1}"

'#{1 + 1}' #=> "\#{1 + 1}"

%(1 + 1 is #{1 + 1}) #=> "1 + 1 is 2"

"con" "cat" "en" "at" "ion" #=> "concatenation"
"This string contains "\
  "no newlines."              #=> "This string contains no newlines."

%q{a} 'b' "c" #=> "abc"
"a" 'b' %q{c} #=> NameError: uninitialized constant q

?a        #=> "a"
?abc      #=> SyntaxError
?\n       #=> "\n"
?\s       #=> " "
?\\       #=> "\\"
?\u{41}   #=> "A"
?\C-a     #=> "\x01"
?\M-a     #=> "\xE1"
?\M-\C-a  #=> "\x81"
?\C-\M-a  #=> "\x81", same as above
?あ       #=> "あ"
?]
?{

foo..
bar
..baz

expected_result = <<HEREDOC
This would contain specially formatted text.

That might span many lines
HEREDOC

expected_result = <<-INDENTED_HEREDOC
This would contain specially formatted text.

That might span many lines
  INDENTED_HEREDOC

expected_result = <<~SQUIGGLY_HEREDOC
  This would contain specially formatted text.

  That might span many lines
          SQUIGGLY_HEREDOC

expected_result = <<-'EXPECTED'
One plus one is #{1 + 1}
EXPECTED

puts <<ONE, <<TWO, <<THREE
jksdlfjlksdjf
jsdklf
ONE
jksdlfjskldf
jskldf
TWO
sdjfklsdjfsd
THREE

p expected_result # prints: "One plus one is \#{1 + 1}\n"

puts <<-`HEREDOC`
cat #{__FILE__}
HEREDOC

expected_result = <<-EXPECTED.chomp
One plus one is #{1 + 1}
EXPECTED

:"my_symbol1"
:"my_symbol#{1 + 1}"

:'my_symbol#{1 + 1}' #=> :"my_symbol\#{1 + 1}"

[1, 1 + 1, 1 + 2]
[1, [1 + 1, [1 + 2]]]

{ "a" => 1, "b" => 2 }
{ a: 1, b: 2 }
{ "a 1": 1, "b #{1 + 1}": 2 }
{ :"a 1" => 1, :"b 2" => 2 }

(1..2)  # includes its ending value
(1...2) # excludes its ending value
(1..)   # endless range, representing infinite sequence from 1 to Infinity
(..1)   # beginless range, representing infinite sequence from -Infinity to 1

/my regular expression/
/my regular expression/i

%r+jskdlfjlskdf+imx

-> { 1 + 1 }
->(v) { 1 + v }

%w[one\\\] one-hundred\ \[ one]
#=> ["one", "one-hundred one"]

# On a separate line
class Foo # or at the end of the line
  # can be indented
  def bar
    jksdlf
=begin
  jksdfjsldf
  =begin
    sjdkflsdf
    sjdkfl
=end
    jklsdf
  end
end

=begin
jksldfjklasdjfa
  sdf
asdfa
=begin
sd
asdf
sdf
fasd
as

asdf
  jklsdf
=end

class Foo
=begin
  jkalsdfjklasdf
  asdjkflasdjf

  jaksldfjlkasdf
  jkasldfjalsdf
    kjlasdjfklasdf
    jaksdlfjasdf

        jklasdjfkalskdfj
=end
  jklsdf
end

class Foo
  jksldfjklsdf
end

1.times do
  a = 1
  puts "local variables in the block: #{local_variables.join ", "}"
end

puts "no local variables outside the block" if local_variables.empty?

a = 0

1.times do
  puts "local variables: #{local_variables.join ", "}"
end

a = 0 if false # does not assign to a

p local_variables # prints [:a]

p a # prints nil

def big_calculation
  42 # pretend this takes a long time
end

big_calculation = big_calculation()

p a if a = 0.zero?

class C
  def initialize(value)
    @instance_variable = value
  end

  def value
    @instance_variable
  end
end

object1 = C.new "some value"
object2 = C.new "other value"

p object1.value # prints "some value"
p object2.value # prints "other value"

class A
  @@class_variable = 0

  def value
    @@class_variable
  end

  def update
    @@class_variable = @@class_variable + 1
  end
end

class B < A
  def update
    @@class_variable = @@class_variable + 2
  end
end

a = A.new
b = B.new

puts "A value: #{a.value}"
puts "B value: #{b.value}"

puts "update A"
a.update

puts "A value: #{a.value}"
puts "B value: #{b.value}"

puts "update B"
b.update

puts "A value: #{a.value}"
puts "B value: #{b.value}"

puts "update A"
a.update

puts "A value: #{a.value}"
puts "B value: #{b.value}"

$global = 0

class C
  puts "in a class: #{$global}"

  def my_method
    puts "in a method: #{$global}"

    $global = $global + 1
    $other_global = 3
  end
end

C.new.my_method

puts "at top-level, $global: #{$global}, $other_global: #{$other_global}"
puts "at top-level, $global: #$global, @instance: #@instance, @@class: #@@class"

X = 1
NAMES = %w[Bob Jane Jim]

class A
  # ...
end
# Roughly equivalent to:
A = Class.new do
  # ...
end

a ||= 0
a &&= 1

p a # prints 1

a, b = 1, 2

p a: a, b: b # prints {:a=>1, :b=>2}

def value=(value)
  p assigned: value
end

self.value, $global = 1, 2 # prints {:assigned=>1}

p $global # prints 2

old_value = 1

new_value, old_value = old_value, 2

p new_value: new_value, old_value: old_value
# prints {:new_value=>1, :old_value=>2}

a, *b = 1, 2, 3

p a: a, b: b # prints {:a=>1, :b=>[2, 3]}

*a, b = 1, 2, 3

p a: a, b: b # prints {:a=>[1, 2], :b=>3}

a, (b, c) = 1, [2, 3]

p a: a, b: b, c: c # prints {:a=>1, :b=>2, :c=>3}

a, (b, *c), *d = 1, [2, 3, 4], 5, 6

p a: a, b: b, c: c, d: d
# prints {:a=>1, :b=>2, :c=>[3, 4], :d=>[5, 6]}

if true then
  puts "the test resulted in a true-value"
end

if false
  puts "the test resulted in a true-value"
else
  puts "the test resulted in a false-value"
end

a = 1

if a == 0
  puts "a is zero"
elsif a == 1
  puts "a is one"
else
  puts "a is some other value"
end

input_type =
  if gets =~ /hello/i
    "greeting"
  else
    "other"
  end

unless true
  puts "the value is a false-value"
end

case "12345"
when /^1/
  puts "the string starts with one"
else
  puts "I don't know what the string starts with"
end

case "2"
when /^1/, "2"
  puts "the string starts with one or is '2'"
end

case a
when 1, 2 then puts "a is one or two"
when 3    then puts "a is three"
else           puts "I don't know what a is"
end

a = 2

case
when a == 1, a == 2
  puts "a is one or two"
when a == 3
  puts "a is three"
else
  puts "I don't know what a is"
end

case {a: 1, b: 2, c: 3}
in a: Integer => m
  "matched: #{m}"
else
  "not matched"
end
# => "matched: 1"

a = 0

while a < 10 do
  p a
  a += 1
end

p a

a = 0

until a > 10
  p a
  a += 1
end

p a

# Not idiomatic
for i in 0..3
  # ...
end
# Idiomatic
(0..3).each do |i|
  # ...
end

# Not idiomatic: selecting items
odds = []
for value in [1, 2, 3, 4, 5]
  odds.push(value) if value.odd?
end
# Still not idiomatic: just each
odds = []
[1, 2, 3, 4, 5].each do |value|
  odds.push(value) if value.odd?
end
# Idiomatic: specialized Enumerable method
odds = [1, 2, 3, 4, 5].select { |value| value.odd? }
# Simplify with Symbol#to_proc
odds = [1, 2, 3, 4, 5].select(&:odd?)

a += 1 while a < 10
a += 1 until a > 10

begin
  a += 1
end while a < 10

values.each do |value|
  break if value.even?

  # ...
end

while true do
  p a
  a += 1

  break if a < 10
end

result = [1, 2, 3].map do |value|
  next if value.even?

  value * 2
end

result = [1, 2, 3].each do |value|
  break value * 2 if value.even?
end

while result.length < 10 do
  result << result.length

  redo if result.last.even?

  result << result.length + 1
end

if true; 1 end # expression (and therefore statement)
1 if true      # statement (not expression)

stmt if v = expr rescue x
stmt if v = expr unless x

0.upto 10 do |value|
  selected << value if value==2..value==8
end

0.upto 5 do |value|
  selected << value if value==2..value==2
end

0.upto 5 do |value|
  selected << value if value==2...value==2
end

def connect_to_db(config) # imagine config is a huge configuration hash from YAML
  # this statement will either unpack parts of the config into local variables,
  # or raise if config's structure is unexpected
  config in {connections: {db: {user:, password:}}, logging: {level: log_level}}
  p [user, passsword, log_level] # local variables now contain relevant parts of the config
  # ...
end

case config
in String
  JSON.parse(config)                    # ...and then probably try to match it again

in version: '1', db:
  # hash with {version: '1'} is expected to have db: key
  puts "database configuration: #{db}"

in version: '2', connections: {database:}
  # hash with {version: '2'} is expected to have nested connection: database: structure
  puts "database configuration: #{database}"

in String => user, String => password
  # sometimes connection is passed as just a pair of (user, password)
  puts "database configuration: #{user}:#{password}"

in Hash | Array
  raise "Malformed config structure: #{config}"
else
  raise "Unrecognized config type: #{config.class}"
end

case [1, 2]
in Integer => a, Integer
  "matched: #{a}"
else
  "not matched"
end
#=> "matched: 1"

case {a: 1, b: 2, c: 3}
in a: Integer => m
  "matched: #{m}"
else
  "not matched"
end
#=> "matched: 1"

case {name: 'John', friends: [{name: 'Jane'}, {name: 'Rajesh'}]}
in name:, friends: [{name: first_friend}, *]
  "matched: #{first_friend}"
else
  "not matched"
end
#=> "matched: Jane"

expectation = 18
case [1, 2]
in ^expectation, *rest
  "matched. expectation was: #{expectation}"
else
  "not matched. expectation was: #{expectation}"
end
#=> "not matched. expectation was: 18"

case Point.new(1, -2)
in x: 0.. => px
  "matched: #{px}"
else
  "not matched"
end

class SuperPoint < Point
end

case Point.new(1, -2)
in SuperPoint(x: 0.. => px)
  "matched: #{px}"
else
  "not matched"
end
#=> "not matched"

case SuperPoint.new(1, -2)
in SuperPoint[x: 0.. => px] # [] or () parentheses are allowed
  "matched: #{px}"
else
  "not matched"
end
#=> "matched: 1"

def hello
  "hello"
end

:+
:-
:*
:**
:/
:%
:&
:^
:>>
:<<
:==
:!=
:!
:!@
:===
:=~
:!~
:~@
:<=>
:<
:<=
:>
:>=

class C
  def -@
    puts "you inverted this object"
  end
end

obj = C.new

-obj # prints "you inverted this object"

class C
  def [](a, b)
    puts a + b
  end

  def []=(a, b, c)
    puts a * b + c
  end
end

obj = C.new

obj[2, 3]     # prints "5"
obj[2, 3] = 4 # prints "10"

def add_one value
  value + 1
end

def my_method((a, b))
  p a: a, b: b
end

def my_method(a, (b, c), d)
  p a: a, b: b, c: c, d: d
end

def gather_arguments(first: nil, **rest)
  p first, rest
end

def my_method
  yield self
end

def each_item(&block)
  @items.each(&block)
end

def my_method
  # code that may raise an exception
rescue
  # handle exception
else
  # only run if no exception raised above
ensure
  # code that runs even if previous code raised an exception
end

alias new_name old_name
alias :new_name :old_name

$old = 0

alias $new $old

p $new # prints 0

undef method1, method2

REGEX = /(ruby) is (\w+)/i
"Ruby is awesome!".match(REGEX).values_at(1, 2)
# => ["Ruby", "awesome"]
"Python is fascinating!".match(REGEX).values_at(1, 2)
# NoMethodError: undefined method `values_at` for nil:NilClass
"Python is fascinating!".match(REGEX)&.values_at(1, 2)
# => nil

"Python is fascinating!".match(REGEX)&.values_at(1, 2).join(' - ')
# NoMethodError: undefined method `join` for nil:NilClass
"Python is fascinating!".match(REGEX)&.values_at(1, 2)&.join(' - ')
# => nil

my_method do |argument1, argument2|
  # ...
end

my_method do |obj; place|
  place = "block"
  puts "hello #{obj} this is #{place}"
end

module Outer::Inner::GrandChild
end

module A
  Z = 1
end

module A::B
  p Module.nesting #=> [A::B]
  p Z #=> raises NameError
end

class B < A
  def m
    1
  end

  protected :m

end

# 1. Define visibility for several methods at once
private

def private_method1
  # ...
end

def private_method2
  # ...
end

public

def public_again
  # ...
end

# 2. Postfactum definition
def private_method1
  # ...
end

def private_method2
  # ...
end

private :private_method1, :private_method2

# 3. Inline definition
private def private_method1
  # ...
end

private def private_method2
  # ...
end

[0, 1, 2].map do |i|
  10 / i
rescue ZeroDivisionError
  nil
end

begin
  # ...
rescue => exception
  warn exception.message
  raise # re-raise the current exception
end

BEGIN {
  count = 0
}

$\ = ' -- '
"waterbuffalo" =~ /buff/
print $', $$, "\n"

require "English"

$OUTPUT_FIELD_SEPARATOR = ' -- '
"waterbuffalo" =~ /buff/
print $POSTMATCH, $PID, "\n"

$!
$@
$~
$&
$`
$'
$+
$1
$=
$/
$\
$,
$;
$.
$<
$>
$_
$0
$*
$$
$?
$LOAD_PATH
$stdin
$-a

TRUE FALSE NIL
STDIN

class A
  [:+, :-, :*, :/].each do |op|
    define_method(op) {
      # ...
    }
  end
end

# Call methods, names stored in variable
[:+, :-, :*, :/].map { |op| 100.send(op, 10) } #=> [110, 90, 1000, 10]

# Create classes and assign to constants
[:A, :B, :C].each { |name| Kernel.const_set(name, Class.new) }

class MyObjectSystem < BasicObject
  DELEGATE = [:puts, :p]

  def method_missing(name, *args, &block)
    return super unless DELEGATE.include? name
    ::Kernel.send(name, *args, &block)
  end

  def respond_to_missing?(name, include_private = false)
    DELEGATE.include?(name) or super
  end
end

# +return+ in non-lambda proc, +b+, exits +m2+.
# (The block +{ return }+ is given for +m1+ and embraced by +m2+.)
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1 { return }; $a << :m2 end; m2; p $a
#=> []

# +break+ in non-lambda proc, +b+, exits +m1+.
# (The block +{ break }+ is given for +m1+ and embraced by +m2+.)
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1 { break }; $a << :m2 end; m2; p $a
#=> [:m2]

# +next+ in non-lambda proc, +b+, exits the block.
# (The block +{ next }+ is given for +m1+ and embraced by +m2+.)
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1 { next }; $a << :m2 end; m2; p $a
#=> [:m1, :m2]

# Using +proc+ method changes the behavior as follows because
# The block is given for +proc+ method and embraced by +m2+.
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1(&proc { return }); $a << :m2 end; m2; p $a
#=> []
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1(&proc { break }); $a << :m2 end; m2; p $a
# break from proc-closure (LocalJumpError)
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1(&proc { next }); $a << :m2 end; m2; p $a
#=> [:m1, :m2]

# +return+, +break+ and +next+ in the stubby lambda exits the block.
# (+lambda+ method behaves same.)
# (The block is given for stubby lambda syntax and embraced by +m2+.)
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1(&-> { return }); $a << :m2 end; m2; p $a
#=> [:m1, :m2]
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1(&-> { break }); $a << :m2 end; m2; p $a
#=> [:m1, :m2]
$a = []; def m1(&b) b.call; $a << :m1 end; def m2() m1(&-> { next }); $a << :m2 end; m2; p $a
#=> [:m1, :m2]

p = proc {|x, y| "x=#{x}, y=#{y}" }
p.call(1, 2)      #=> "x=1, y=2"
p.call([1, 2])    #=> "x=1, y=2", array deconstructed
p.call(1, 2, 8)   #=> "x=1, y=2", extra argument discarded
p.call(1)         #=> "x=1, y=", nil substituted instead of error

l = lambda {|x, y| "x=#{x}, y=#{y}" }
l.call(1, 2)      #=> "x=1, y=2"
l.call([1, 2])    # ArgumentError: wrong number of arguments (given 1, expected 2)
l.call(1, 2, 8)   # ArgumentError: wrong number of arguments (given 3, expected 2)
l.call(1)         # ArgumentError: wrong number of arguments (given 1, expected 2)

def test_return
  -> { return 3 }.call      # just returns from lambda into method body
  proc { return 4 }.call    # returns from method
  return 5
end

test_return # => 4, return from proc

def m1(&b) b.call end; def m2(); m1 { return } end; m2 # ok
def m1(&b) b.call end; def m2(); m1 { break } end; m2 # ok

def m1(&b) b end; def m2(); m1 { return }.call end; m2 # ok
def m1(&b) b end; def m2(); m1 { break }.call end; m2 # LocalJumpError

def m1(&b) b end; def m2(); m1 { return } end; m2.call # LocalJumpError
def m1(&b) b end; def m2(); m1 { break } end; m2.call # LocalJumpError

class SizeMatters
  include Comparable
  attr :str
  def <=>(other)
    str.size <=> other.str.size
  end
  def initialize(str)
    @str = str
  end
  def inspect
    @str
  end
end

class Tally < Numeric
  def initialize(string)
    @string = string
  end

  def to_s
    @string
  end

  def to_i
    @string.size
  end

  def coerce(other)
    [self.class.new('|' * other.to_i), self]
  end

  def <=>(other)
    to_i <=> other.to_i
  end

  def +(other)
    self.class.new('|' * (to_i + other.to_i))
  end

  def -(other)
    self.class.new('|' * (to_i - other.to_i))
  end

  def *(other)
    self.class.new('|' * (to_i * other.to_i))
  end

  def /(other)
    self.class.new('|' * (to_i / other.to_i))
  end
end

(-1..-5).to_a      #=> []
(-5..-1).to_a      #=> [-5, -4, -3, -2, -1]
('a'..'e').to_a    #=> ["a", "b", "c", "d", "e"]
('a'...'e').to_a   #=> ["a", "b", "c", "d"]

class Xs                # represent a string of 'x's
  include Comparable
  attr :length
  def initialize(n)
    @length = n
  end
  def succ
    Xs.new(@length + 1)
  end
  def <=>(other)
    @length <=> other.length
  end
  def to_s
    sprintf "%2d #{inspect}", @length
  end
  def inspect
    'x' * @length
  end
end

def ext_each(e)
  while true
    begin
      vs = e.next_values
    rescue StopIteration
      return $!.result
    end
    y = yield(*vs)
    e.feed y
  end
rescue
  jksldf
end

o = Object.new

def Foo.each
end

def o.each
  puts yield
  puts yield(1)
  puts yield(1, 2)
  3
end

class Foo::Bar::Baz
end

class Book
  attr_reader :author, :title

  def initialize(author, title)
    @author = author
    @title = title
  end

  def ==(other)
    self.class === other and
      other.author == @author and
      other.title == @title
  end

  alias eql? ==

  def hash
    @author.hash ^ @title.hash # XOR
  end
end

begin
  puts "Press ctrl-C when you get bored"
  loop {}
rescue Interrupt => e
  puts "Note: You will typically use Signal.trap instead."
end

42 /  0.0   #=> Float::INFINITY
42 / -0.0   #=> -Float::INFINITY
0  /  0.0   #=> NaN

pid = fork do
  Signal.trap("USR1") do
    $debug = !$debug
    puts "Debug now: #$debug"
  end
  Signal.trap("TERM") do
    puts "Terminating..."
    shutdown()
  end
  # . . . do some work . . .
end

require 'io/console'

Thread.new {
  Thread.current[:foo] = "bar"
  Fiber.new {
    p Thread.current[:foo] # => nil
  }.resume
}.join

Thread.new{
  Thread.current.thread_variable_set(:foo, 1)
  p Thread.current.thread_variable_get(:foo) # => 1
  Fiber.new{
    Thread.current.thread_variable_set(:foo, 2)
    p Thread.current.thread_variable_get(:foo) # => 2
  }.resume
  p Thread.current.thread_variable_get(:foo)   # => 2
}.join

class SimpleDelegator < Delegator
  def __getobj__
    @delegate_sd_obj # return object we are delegating to, required
  end

  def __setobj__(obj)
    @delegate_sd_obj = obj # change delegation object,
    # a feature we're providing
  end
end

class Stats
  def initialize
    @source = SimpleDelegator.new([])
  end

  def stats(records)
    @source.__setobj__(records)

    "Elements:  #{@source.size}\n" +
      " Non-Nil:  #{@source.compact.size}\n" +
      "  Unique:  #{@source.uniq.size}\n"
  end
end

foo = if true
        "foo"
      else
        "bar"
      end

foo + if true
        "foo"
      else
        "bar"
      end

x_to_y_mapping = {
  'x_one' => %i[
    y_one
    y_two
  ],
  'x_two' => %i[
    y_three
    y_four
  ]
}

FOO = "bar"
result = [].<<FOO

x_to_y_mapping = {
  'x_one' => [
    :y_one,
    :y_two
  ],
  'x_two' => [
    :y_three,
    :y_four
  ]
}

let(:source) do
  # Empty lines should make no difference.
  <<~RUBY
  if #{condition}
  #{body}
  end
  RUBY
end

if bleh
  case a
  when b then [c, <<~STR]
    the quick brown fox jumped over the lazy dog.
  STR
  end
end

module Test
  class Test
    def test
      [<<~SQL]
        TEST
      SQL
    end

    def other_method
    end
  end
end

def show
  render json: { headers: data[:headers], just_key: data[:data] }
end

# Floating indentation samples:

<<-string # => "  hello\n    world"
                hello
        world
                 string

foo = 1 + 5 -
      10 * 4 /
      bar

foo =
  1 + 5 -
  10 * 4 /
  bar

foo,
  bar,
  jksldf

foo bar: 1,
  baz: 2,
  bleh: 3

foo(
  bar
  jksldf
  jksdlf
)

foo { |foo|
  foo * 2
}

foo(bleh: {
  jksldfjklsdf
})

if foo
  bar
end

x = "if foo bar end"

if foo
  if bar  # jskdljskldf
  end
end

jksldf =
  begin
    jksldf
  rescue bleh
    jskdlf
  end

(foo) +
  bar

foo = [:foo, :bar,
       "bleh", "bloo",
       :baz, :qux]

<<-some.upcase # => "hello"
                 hello
      some

def upcase(string)
  string.upcase
end

def [](regex,
       x,
       y,
       group)
  match[group] if match
  jksdlf
  jskldf
  jksldfjklsdf
end

x = [
  1
] + [
  3
]

x = if y
      5
    else
      10
    end

x = begin
      h["foo"]
    rescue => exception
      "Not Found"
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

x = y.foo
     .bar
     .baz

x = y
  .foo
  .bar
  .baz

method_call one,
  two {
    three
  }

method_call one,
  two do
    three
  end

foo =
  begin
    jksldfjsdf
  end

x = case y
    when 1
      "foo"
    when 2
      "bar"
    when 3 then "baz"
    when 4
      "bleh"
      "bloo"
    when 5 then
      "jskdlf"
    else
      "blerp"
    end

def foo(x, y = 123, z = 123)
  jksldfjklsdf
end

::Kernel.send(name)
::FOO::BAR

class Foo::Bar::Baz
  def self.foo
    "foo"
  end

  def Baz.bar
    "bar"
  end
end

!foobar
~foobar

def some_method
  something_dangerous
ensure
  # always execute this
end

foo if bar

module Ticker
  def self.on_tick(&callback)
    boxed_data = Box.box(callback)

    @@box = boxed_data

    LibTicker.on_tick(->(tick, data) {
      data_as_callback = Box(typeof(callback)).unbox(data)
      data_as_callback.call(tick)
    }, boxed_data)
  end
end

Ticker.on_tick do |tick|
  puts tick
end

%( (\))\)\(\) )
jkl
%(\()

%(jkl)

"jksldf'jklsdf" jksdlfjklsdf

%w(foo bar baz)  #
%w(foo\nbar baz)  #
%w(foo(bar) baz)  #
%w(foo\ bar #{baz})  #
%( foo\ (bar) baz )  #

%r(jkl|jksldfjklsdf #{jklsdf}?)

{ name: "Ruby", year: 2011 }, { "this is a key": 1 }

foo12

input = %w(nail shoe horse rider message battle kingdom)

one = -> do
  output = []

  input.each_cons_pair do |a, b|
    output << "For want of a #{a} the #{b} was lost."
  end

  output << "And all for the want of a #{input.first}."

  return output
end

foo x: 1, y: 2

def foo(*foo, **x, y = 2)
  foo x: 1, y: 2
end

x = { foo: 1, bar: 2, BAR: 12 }

def foo
  jksldf
  # jksldf sdf
end

0.123
0x123
0x123f32
0x123e10
0.123E-12_432432
0.012
0E123
0xFE012D
1_000_000
1_000_000.111_111

:foo

foo.+ bar: 3

"\012jksldfjklsdf"

foo:bar
{foo:"bar"}
foo :"bar"
Foo::Bar
foo? bar: bleh
foo ? 123 : bleh
foo ? 123 : Bleh
foo ? foo : Bleh
foo ? foo : Bleh ? Bleh : Bloo
foo ? foo : Bleh ? ( foo bar: bleh ? :bar : :bleh ) : Bloo
foo ? foo x: 1, y: 2 : Bleh

"#{foo bar: bleh}"

foo = x ? y : z
foo = Foo ? Bar : Baz

puts 1 / 2, 3 / 4

foo /= bar / baz

!Foo
~(foo) + bleh
jklasdf

$~jkl
$_jkljkll + :foo + $1 /a/ $2
$?jkl
$1jkl

123E12

@jkfldsfd
@@jkflds fdlks

@jfkdsl
@@FJKLJKLKK
[ 1, 2, 3 ]

if foo[0] / jklfds / bjkrlew
  :bar
end

if foo[0] / jkflds / sjdkflsdf
  :bar jskdlf
end

jksldf = begin
           jksldf
         rescue bleh
           jskdlf
         end

sjkdflsdf

->(x, y) { x + y }

0.. + ..123

'\''

%w(foo\ bar)  #
%w(foo\\ bar)  #

%i(foo\ bar)  #
%i(foo\\ bar)  #

if x / /bar/ / bleh / /boo/
  boop
end

if x / bar / bleh / boo
  beep
end

def one
  1
end

close_door unless door_closed?

proc = ->str.count(Char)
proc.call

class Person
  private def say(message)
    puts message
  end
end

def some_method(x, y = 1, z = 2, w = 3)
  # do something...
end

some_method 10
some_method 10, z: 10
some_method 10, w: 1, y: 2, z: 3

foo *tuple

$? success?

object.[]=(2, 3)

if a = some_expression
  jksldjflksdf
end

@a.try do |a|
  jksldfjksldf
end

x / y / z

foo.begin

foo?(bar)+:bleh
foo? bar:(bleh)

foo /fds/, /bar/, x / y

foo = %w(jkl), "foo", %w(foo bar), x % y % z

foo.x & bar.y

foo bar: 1, baz: 2

foo :bleh, :bloo, %w(foo bar baz)
foo %(jkljkljkl)
foo /bleh/, /bloo/

foo <<-TEXT
            jkalsdjfkl
            TEXT

print(<<-'FIRST', <<-SECOND)
            hello
            FIRST
            World
            SECOND
jksldf

print(<<-'FIRST', <<-SECOND, <<-'THIRD')
            hello
            FIRST
            World
            SECOND
            jksldf
            #{jksldf}
            jskdlfjklsdfj
            THIRD
jksdlf

foo "jklasdf", 'j', %w(foo bar baz)

'\u{1234}'

foo BAR::BAZ

:"fo\"o#{jkalsdf, 5} bar"

foo.each do
  jklasdf
end

foo ? bar : baz

if foo
  jkl
end

foo.each {
  jklsdfsdf
}

foo &:bar

foo & bar

bleh BAR: BAR::BAZ, foo: 123, bar: jklsdf do
  jkl
end

while true
  blerp
end

until false
  blorp
end

foo.each do
  jklasdf
end

foo.each do |fdjksl, bloo = 123|
  bleh
  bloo
end

get :doo do
  jklsdf
end

$1
$?

:unquoted_symbol
:"quoted symbol"
:"a"

:question?
:exclamation!

foo.each { |bleh|
  { 1, 2 }
  jksdlfjksldf
  jksldf
  jlksdf
  { 3, 4 }
}

foo +
  bar

foo = /bar/

foo /= x / y
foo /= x % y
foo /= /=/ / // / bleh / bloop

foo = /foo|bar/

foo = /h(e+)llo/
foo =~ /\d+/ / /foo/ / bleh
foo = /あ/

foo /= jkl / bar

if foo /foo/ =~ bleh
  /asdf/
end

def foo(jkalsdfasdf)
  /asdf/
end

/\//                  # slash
/\\/                  # backslash
/\b/                  # backspace
/\e/                  # escape
/\f/                  # form feed
/\n/                  # newline
/\r/                  # carriage return
/\t/                  # tab
/\v/                  # vertical tab
/\123/                # octal ASCII character
/\x12/                # hexadecimal ASCII character
/\u{1324}/            # hexadecimal unicode character
/\u{1111 AFFFFF 123}/ # hexadecimal unicode characters

"\u{1234}"

/a(sd)f/.match("_asdf_")                     # => #<Regex::MatchData "asdf" 1:"sd">
/a(?<grp>sd)f/.match("_asdf_")               # => #<Regex::MatchData "asdf" grp:"sd">

/a\Qjkls\b\\dfjklsdf|jksldf\Ejksl(?imx)dfjlksdf|jksdl#{jksdlf + 123}fjkls{{ foo + 123 }}df/
/jskldf{,123}\123\g{foo}\g<foo>/

/foo|bar/.match("foo")     # => #<Regex::MatchData "foo">
/foo|bar/.match("bar")     # => #<Regex::MatchData "bar">
/_(x|y)_/.match("_x_")     # => #<Regex::MatchData "_x_" 1: "x">
/_(x|y)_/.match("_y_")     # => #<Regex::MatchData "_y_" 1: "y">
/_(x|y)_/.match("_(x|y)_") # => nil
/_(x|y)_/.match("_(x|y)_") # => nil
/_._/.match("_x_")         # => #<Regex::MatchData "_x_">
/_[xyz]_/.match("_x_")     # => #<Regex::MatchData "_x_">
/_[a-z]_/.match("_x_")     # => #<Regex::MatchData "_x_">
/_[^a-z[:alnum:]]_/.match("_x_")    # => nil
/_[^a-wy-z]_/.match("_x_") # => #<Regex::MatchData "_x_">

%r((/)())   # => /(\/)/
%r[[/][]]   # => /[\/]/
%r[[/\][]]  # => /[\/]/
%r{{/}{}}   # => /{\/}/
%r{\{/\}{}} # => /{\/}/
%r<</><>>   # => /<\/>/

%(( jklj\n ))  #
%[ [ [ ] \[jklj\n ]]  #
%{{ jklj\n }}  #
%<< jklj\n >>  #
"foo\("  #

"jk\[\]\{lasdf#{1}\#{2}"

"\"" # double quote
"\\" # backslash
"\e" # escape
"\f" # form feed
"\n" # newline
"\r" # carriage return
"\t" # tab
"\v" # vertical tab
"\u0041" # == "A"
"\u{41}" # == "A"
"hello " \
  "sdfjklsdf" \
  "jksldfjklsdf" \
  "world, " \
  "no newlines" # same as "hello world, no newlines"

foo = "hello
sdfsdfds
jksldf world \"
        jklsdf" + :foo

x + " foo " +
    " bar " +
    jskldfjklsdf +
    jaksldf
jksldfjsdf

# Supports double quotes and nested parentheses
%(hello ("world")) # same as "hello (\"world\")"

# Supports double quotes and nested brackets
%[hello ["world"]] # same as "hello [\"world\"]"

# Supports double quotes and nested curlies
%{hello {"world"}} # same as "hello {\"world\"}"

# Supports double quotes and nested angles
%<hello <"world">> # same as "hello <\"world\">"

unless foo + bar - bleh
  jklasdf
end

<<-STRING # => "Hello\n  world"
            Hello
            world
            <F5>
              jklasdfasdf
            jkalsdfasdf
            #{jklasdfasdf}
            jklsdfsdf
            STRING

upcase <<-SOME, "bleh" # => jkl
            jklsdf
            SOME

upcase(<<-SOME, :bleh, "bleh", 'b', /bleh/ / foo) # => "HELLO"
            hello
            SOME

upcase(<<-'SOME', "bleh")  # => "HELLO"
            foo
            bar
            SOME

<<-HERE
            hello \n \#{world}
            HERE

<<-HERE
            hello \n #{world}
            HERE

foo = <<-'HERE' # => "hello \\n \#{world}"
            hello \n #{world}
            HERE

foo = <<-'HERE' # => jklasdf
            hello \n #{wordl}
            HERE

:"jklsdfjklsdf"

a = 1
b = 2
"sum = #{foo { |a, b| jksldfjklsdf + {{ foo { |x| x ** 2 } }} + 123 }} jksldfsdf"
"sum = #{foo { |a, b| jskldf { |x, y| x + {{ 123 }} + 123 } }} + 1" # "sum = 3"

$1
$1232321321

# Octal escape sequences
"\101" # # => "A"
"\12"  # # => "\n"
"\1"   # string with one character with code point 1
"\377" # string with one byte with value 255

# Hexadecimal escape sequences
"\x41" # # => "A"
"\xFF" # string with one byte with value 255

class Foo
  def [](foo, bar)
    @foo
  end

  if @foo
    jklasdfasdf
  end

  def !~
    jksldf
    jksdlf
  end

  def begin?
  end

  def ===
  end
end

case array
in [1, 2]
in [1, 2, a]
  puts a
end

case exp
in [1, a]
  puts a
else
  puts "No match"
  "'"
end

if null_checked_value = array[3]
  /foo/
  puts value + 2
  exit 0
end

if foo =~ /bar/
  bleh
end

if foo =~ /bar/
  bleh
end

foo ?
  bar : Bleh

foo.self
foo.nil
foo.__FILE__
foo.true.true
   .false
   .jaskldf

self
nil
__FILE__
true

# result:
if null_checked_value = array[3]
  puts value + 2
  exit 0
end

foo.bar?

foo = (bar,
       bleh,
       blerp,
       blorp,
       bloo)

foo = {
  x: 1,
  y: 2,
  z: 3
}

foo..
bar

foo = (
  bleh,
  bloo,
  bar +
    bleh -
    bloo * fjdkls,
  jskdlf
)

foo = (
  bleh,
  bloo,
  bar + bleh -
        bloo * fjkdlsjfklds,
  jksldf
)

foo = (
  bleh,
  bar + bleh -
        jskdlfjklsdf
)

foo bar,
  baz,
  bleh,
  123

@Foo
@_FDOISfdsfds_123
@f123
@fds
@@foo

foo._Bar

FOo12__3

{foo:bar}
foo:"bar"
Foo::Bar
foo?bar:bleh

foo.begin

foo?(bar) :bleh
foo? bar:(bleh)

'\u{1234}'

:"foo#{jkalsdf} bar"

foo = :[]
foo = :<<
bar **= :+

foo + bar

:**,
  :+,
  :[],
  :<<,
  :<=>,
  :!,
  true

foo = bar(bleh, blerp,
          jklsdf, fjdklsajfkdlsa)

private def dump_or_inspect(io)
  io << '"'
  dump_or_inspect_unquoted(io) do |char, error|
    yield char, error
  end
  io << '"'
end

if foo
end

"\\'foo\\\\\\\""

foo[123]

x = if true
      5
    else
      10
    end

x + if true
      5
    else
      10
    end

case x
in foo
  5
in [Foo, Bar]
  jklasdf
end

x = if true 5 else 10 end

x = if true
      5
    else
      10
    end

x = "if"
bar

foo = ([%{jk(l[{}]}])

foo(
  bar(
    {
      x: 1,
      y: 2,
      "do": 3,
      "foo bar": 4
    }
  )
)

# This generates:
#
#     def foo
#       1
#     end
define_method foo, 1

bar.foo= 123

foo[0]= 123

:+
:-
:*
:**
:/
:==
:===
:=~
:!=
:!~
:!
:<=>
:<=
:<<
:<
:>=
:>>
:>
:&
:|
:^
:~
:%
:[]=
:[]

true

foo =~ /bar/
bleh

foo = true ? /foo/ : /bar/

foo if bleh

foo # => 1

:"foo bar"

p Foo::Bar.new("John").say # => "hi John"

class Foo
  if bar
    foo
  else
  end
  bleh
end

if foo
  if bar
    foo
  else
    bar
  end
  bleh
end

if 1
  if 2
  else
  end
end

foo = :"
            foo
            "

if true
  5
else
  10
end

x = if true
      5
    else
      10
    end

while true
  if foo
    bar
  else
    bleh
  end
end

def foo
  until true
    do_something
  end
end

def foo
  bleh
rescue Foo
  bloo
end

Foo.boo(0, 1)

VALUES = [1, 2, 3]

%w(foo bar).each do |bleh|
  bleh
end

foo = <<-TEXT
            bleh
            bloo blerp
            TEXT

foo.each do |bleh|
  bleh
end

foo |
  bar

foo ||
  bar

foo /
  bar

foo <<=
  bar

bleh

foo &
  bar

foo &&
  bar

foo ?
  bar : Foo

foo ? bar : bleh

foo?
bar

foo *
  bar

bleh

foo *
  bar

foo =
  bar

foo +=
  bar

foo =~
  bar

foo \
  bar

foo !~
  bleh

foo -
  bar

foo ?
  bar :
  bleh

foo +
  bar +
  bleh

foo ^
  bar

foo ^=
  bar

foo ==
  true

foo =~
  true

foo ===
  bleh

foo !=
  true

foo.each do
  bleh
end

foo(
  foo,
  bar,
  bloop
)

foo(bleh,
    bloo,
    bleh,
    boop)

foo = [
  foo,
  bar,
  bloop,
]

foo = [foo,
       bar,
       bloop]

foo = {
  foo,
  bar,
  bloop,
}

foo = {foo,
       bar,
       bloop}

foo = {
  foo +
    bar -
    bleh,
  blerp,
  jksldf if true,
  jksldf + if true
             jksldfjskdlf
           else
             10
           end,
  jksldfjksldf
}

%w(foo bar).each do
  bleh
end

%w(foo bar).each do
  %w(baz qux).each do
    bleh
  end
end

[1, 2, 3].each do
  bleh
end

:_!

'\''
'a'
'"'
'\a'
'\\'
'\t'
'\u12FD'
"\""
"\`"
'\''

`\``

{foo?: 1, _1?: 2, FOO: 3, _FOO_?: 4}
{"foo": 1, "bar": 2, _A?: 1}

[1, 2, 3].each do
  bleh

  [4, 5, 6].each do |j|
  end

  [1, 2, 3].each do |i|
    [1, 2, 3].each do |j|
      bleh
    end
  end
end

if foo || bar || baz || bing
  puts "foo"
end

[1, 2, 3].each do |i|
  [4, 5, 6].each do |j|
    foo
  end
end

foo.each { |i|
  bleh
}

foo.each {
  bleh
}

%w(foo bar).each {
  bleh
}

%w(foo bar).each {
  %w(baz qux).each {
  }
}

x = {
  x: 1,
  y: 2,
}

[1, 2, 3].each {
  bleh
}

[1, 2, 3].each {
  bleh
}

[1, 2, 3].each {
  bleh

  [4, 5, 6].each { |j|
  }

  [1, 2, 3].each { |i|
    [1, 2, 3].each { |i|
      bleh
    }
  }
}

[1, 2, 3].each { |i|
  [4, 5, 6].each { |j|
    foo
  }
}

%w(foo bar).each do
  bleh
end

%w(foo bar).each do |bleh|
  bleh
end

foo = "bar" \
      "baz"

method_call one,
  two,
  three

method_call(
  other_method_call (
    foo
  )
)

method_call do
  something
  something_else
end

require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world! The time is #{Time.local}"
end

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen

# file: help.cr
require "option_parser"

%(jklasdf)  #
%[bleh]  #
%{bleh}  #
%<bleh>  #

OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

foo?[] + /jksldf/ // jskdlf

# file: twist_and_shout.cr
require "option_parser"

the_beatles = [
  "John Lennon",
  "Paul McCartney",
  "George Harrison",
  "Ringo Starr",
]
shout = false

option_parser = OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
  parser.on "-t", "--twist", "Twist and SHOUT" do
    shout = true
  end
end

members = the_beatles
members = the_beatles.map &.upcase if shout

puts ""
puts "Group members:"
puts "=============="
members.each do |member|
  puts member
end

module Foo
  class Error < Exception; end
end

# :nodoc:
CHAR_TO_DIGIT = begin
                  table = StaticArray(Int8, 256).new(-1)
                  10.times do |i|
                    table.to_unsafe[48 + i] = i
                  end
                  26.times do |i|
                    table.to_unsafe[65 + i] = i + 10
                    table.to_unsafe[97 + i] = i + 10
                  end
                  table
                end

a,
  b,
  c,
  d,
  e

foo?
bar

foo!
bar

next = [1, ["b", [:c, ['d']]]]
flat = Array(typeof(Array.elem_type(nest))).new
typeof(nest)
typeof(flat)

def =~(regex)
  match = regex.match(self)
  $~ = match
end

foo = begin
        jksldf
      end

@def = "bleh"

Foo*
  jksldfsdf
jksldf
Foo?
  jksldf
jskldf

def [](regex, group)
  match[group] if match
  jksldf
  jklsdf
  match = match(regex)
end

# :ditto:
def rindex(search, offset = size - 1)
  offset += size if offset < 0
  return nil unless 0 <= offset <= size

  match_result = nil
  scan(search) do |match_data|
    break if (index = match_data.begin) && index > offset
    match_result = match_data
  end
end

def foo
  foo = $~
  bar
end

require "file_utils"

logger = if Lucky::Env.test?
           # Logs to `tmp/test.log` so you can see what's happening without having
           # a bunch of log output in your specs results.
           FileUtils.mkdir_p("tmp")
           Dexter::Logger.new(
             io: File.new("tmp/test.log", mode: "w"),
             level: Logger::Severity::DEBUG,
             log_formatter: Lucky::PrettyLogFormatter
           )
         elsif Lucky::Env.production?
           # This sets the log formatter to JSON so you can parse the logs with
           # services like Logentries or Logstash.
           #
           # If you want logs like in development use `Lucky::PrettyLogFormatter`.
           Dexter::Logger.new(
             io: STDOUT,
             level: Logger::Severity::INFO,
             log_formatter: Dexter::Formatters::JsonLogFormatter
           )
         else
           # For development, log everything to STDOUT with the pretty formatter.
           Dexter::Logger.new(
             io: STDOUT,
             level: Logger::Severity::DEBUG,
             log_formatter: Lucky::PrettyLogFormatter
           )
         end

Lucky.configure do |settings|
  settings.logger = logger
end

Avram::Repo.configure do |settings|
  settings.logger = logger
end

jksdlfsdf

jksldf

x = if foo
      jksldfjklsdf
      asjkdflasdf
      ajksldf
    end

x = [
  if foo
    bleh
  else
    bloo
  end,
  if blerp
    blorp
  else
    fjkdlsjfklds
  end,
]

x = [
  if foo
    bleh
  else
    bloo
  end,
  foo +
    bar,
  y + if bar
        bleh
      end,
]

x = case y
    when 1
      "foo"
    when 2
      "bar"
    when 3 then "baz"
    when 4
      "bleh"
      "bloo"
    when 5 then
      "jskdlf"
    else
      "blerp"
    end

true if bleh

last_color_is_default =
  @@last_color[:fore] == ColorANSI::Default &&
  @@last_color[:back] == ColorANSI::Default &&
  @@last_color[:mode] == 0

foo
  .bar
  .baz
..jksldfsdf

foo..bar

class Foo
  x = {
    end: 123,
    rescue: jskldf
  }
end

%r((/)()) # => /(\/)/
%r[[/][]] # => /[\/]/
%r{{/}{}} # => /{\/}/
%r<</><>> # => /<\/>/

%{{\{\}}}

class Foo < Bar
  jksldfjlk
end

DEFAULT_FORMATTER = Formatter.new do |severity, datetime, progname, message, io|
  label = severity.unknown? ? "ANY" : severity.to_s
  io << label[0] << ", [" << datetime << " #" << Process.pid << "] "
  io << label.rjust(5) << " -- " << progname << ": " << message
end

def foo
  bar +
    baz +
    bleh
end

def foo(k: 1)
  p k
end

def: increment(x) = x + 1

return foo +
  bar
