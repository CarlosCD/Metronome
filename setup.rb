#!/usr/bin/env -S ruby --enable=jit

# Install the 2D Audio gem, if not present:

has_2d = begin
           Gem::Specification.find_by_name('ruby2d')
           true
         rescue Gem::MissingSpecError
           false
         end

if has_2d
  puts 'You already had the "ruby2d" gem installed.'
else
  system 'gem install ruby2d -v 0.12.1'
end
puts

# Creates the two .wav files

prefix = "\x52\x49\x46\x46\x2C\x00\x00\x00\x57\x41\x56\x45\x66\x6D\x74\x20\x10\x00\x00\x00\x01\x00\x01\x00\x40\x1F\x00\x00\x40\x1F\x00\x00\x01\x00\x08\x00\x64\x61\x74\x61\x40\x1F\x00\x00"
sounds = { tick: prefix + "\x00\xFF\x00\xFF\x00\xFF\x00\xFF",
           tock: prefix + "\x00\x00\xFF\xFF\x00\x00\xFF\xFF" }
sounds.each do |name, content|
  file_name = "#{name}.wav"
  if File.exist?(file_name)
    puts "'#{file_name}' already exists!"
  else
    File.open(file_name, 'w') { |file| file.write(content) }
    puts "'#{file_name}' created"
  end
end
