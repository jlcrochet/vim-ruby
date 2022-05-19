WORDS = %w(0=end 0=else 0=elsif 0=when 0=in 0=rescue 0=ensure 0==begin 0==end)
CHARACTERS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_?!:"

words = []

WORDS.each do |word|
  words << word

  CHARACTERS.each_char do |char|
    words << word + char
  end
end

puts words.join ","
