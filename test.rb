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

-> { 1 + 1 }
->(v) { 1 + v }

%w[one\\\] one-hundred\ \[ one]
#=> ["one", "one-hundred one"]

# On a separate line
class Foo # or at the end of the line
  # can be indented
  def bar
    jksdlf
    jklsdf
  end
end

=begin
This is
  commented out
=end

class Foo
  def foo
    jklsdfjklsdf
=begin
jklsdflkjsdf
=end
    jksldfksjldf
  end
end

=begin some_tag
  jksldfskdf
this works, too
=end

class Foo
=begin
  Will not work
=end
  jklsdf
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
:===
:=~
:!~
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
