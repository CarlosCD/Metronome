#!/usr/bin/env -S ruby --enable=jit

# It assumes the ruby2d gem is present
require 'ruby2d'

bpm = ARGV[0].to_i
bpm = 90 if bpm == 0
bpm = 24 if bpm < 24
bpm = 250 if bpm > 250

# ruby2d gem:
TICK_SOUND = Sound.new('tick.wav')
TOCK_SOUND = Sound.new('tock.wav')
# Default volume is 100
PLAY_TICK = ->(volume = 100) { TICK_SOUND.volume=volume; TICK_SOUND.play }
PLAY_TOCK = ->(volume = 100) { TICK_SOUND.volume=volume; TOCK_SOUND.play }

# # Not volume gem:
# PLAY_TICK = ->(volume = nil) { TICK_SOUND.play }
# PLAY_TOCK = ->(volume = nil) { TOCK_SOUND.play }

# # No ruby2d gem at all, using Mac's afplay:
# afplay: default normal volume is 1 (values 0-255 in logarithmic scale)
# PLAY_TICK = ->(volume = 1) { `afplay ./tick.wav -v #{volume}` }
# PLAY_TOCK = ->(volume = 1) { `afplay ./tock.wav -v #{volume}` }

# Testing the time to play tick.wav & tock.wav in this system (volume zero, if possible)
ts = Time.now
PLAY_TICK.call(0)
tm = Time.now
PLAY_TOCK.call(0)
tf = Time.now

tick_secs = tm - ts
tock_secs = tf - tm
sound_secs = (tick_secs + tock_secs) / 2.0

puts "Tick took #{sprintf('%.5f',tick_secs*1_000)} milliseconds to play."
puts "Tock took #{sprintf('%.5f',tock_secs*1_000)} milliseconds to play."
puts "Average:  #{sprintf('%.5f',sound_secs*1_000)} milliseconds"
puts

# The CALCULATE_SLEEP lambda seems to take (in my machine) between 0.001 and 0.02 millisecs
#   (JIT enabled, disabling GC doesn't seem to impact much):

CALCULATE_SLEEP = ->(sound_time = sound_secs) { (60.0/bpm) - sound_time }
puts "The interval between sounds will be of around #{sprintf('%.5f',CALCULATE_SLEEP.call*1_000)} milliseconds (dynamically adjusted)."

# With running average:
# CALCULATE_SLEEP = ->(sound_time = sound_secs, avg = 0.0, sample_size = 1) { t = (60.0/bpm) - sound_time;[ t, avg + (t - avg)/sample_size ] }
# puts "The interval between sounds will be of around #{CALCULATE_SLEEP.call.first*1_000} milliseconds (dynamically adjusted)."

puts

puts 'Testing the CALCULATED_SLEEP lambda, 100 times:'
mi = 100.0
ma = 0.0
GC.disable
1.upto(100) do |n|
  t0 = Time.now
  CALCULATE_SLEEP.call
  t = Time.now - t0
  puts "Test #{sprintf('%00d',n)}: #{sprintf('%.50f',t*1_000)} millisecs"
  mi = t if t < mi
  ma = t if ma < t
end
GC.enable
puts "min: #{sprintf('%.50f',mi*1000)}"
puts "max: #{sprintf('%.50f',ma*1000)}"

puts "#{bpm} beats per minute set."
puts
puts 'Press Control & C to stop it...'

# min = 100.0
# max = 0.0
# average = 0.0
# sample_size = 0
begin
  # GC.disable
  while true do
    t0 = Time.now
    PLAY_TICK.call
    # sample_size += 1
    # sleep_time, average = CALCULATE_SLEEP.call(Time.now-t0, average, sample_size)
    # sleep sleep_time
    sleep CALCULATE_SLEEP.call(Time.now-t0)
    # min = sleep_time if sleep_time < min
    # max = sleep_time if max < sleep_time

    t0 = Time.now
    PLAY_TOCK.call
    # sample_size += 1
    # sleep_time, average = CALCULATE_SLEEP.call(Time.now-t0, average, sample_size)
    # sleep sleep_time
    sleep CALCULATE_SLEEP.call(Time.now-t0)
    # min = sleep_time if sleep_time < min
    # max = sleep_time if max < sleep_time
  end
rescue Interrupt
  puts
  # puts "min: #{sprintf('%.100f',min*1_000)}"
  # puts "max: #{sprintf('%.100f',max*1_000)}"
  # puts "avg: #{sprintf('%.100f',average*1_000)}"
  puts 'Bye!'
ensure
  # GC.enable
end
