#!/usr/bin/env -S ruby --enable=jit

class Metronome
  def initialize(args)
    @can_play = true
    @has_2d = begin
                require 'ruby2d'
              rescue LoadError
                false
              end
    # Arg #1, Beats Per Minute:
    @bpm = args[0].to_i
    @bpm = 90 if @bpm == 0
    @bpm = 24 if @bpm < 24
    @bpm = 250 if @bpm > 250
    # Arg #2, extra options:
    optional_param = args[1].to_s.downcase
    display_help = %w(-h -? --help).include?(optional_param)
    debug_mode = display_help || %w(-d --debug).include?(optional_param)
    # Help:
    if display_help
      puts 'Usage: ./met.rb n flag'
      puts 'Where: n is an integer number between 24 and 250 (required if a flag is used)'
      puts '       flag is one single option, that could be either:'
      puts '         -d, --debug     debug mode'
      puts '         -h, -?, --help  prints these help notes (and also enters in debug mode)'
      puts
    end
    # Sounds, lambdas to play each sound:
    if @has_2d
      tick_sound = Sound.new('tick.wav')
      tock_sound = Sound.new('tock.wav')
      # Default volume is 100
      @play_tick = ->(volume = 100) { tick_sound.volume=volume; tick_sound.play }
      @play_tock = ->(volume = 100) { tock_sound.volume=volume; tock_sound.play }
    elsif RUBY_PLATFORM =~ /darwin/
      # afplay: default normal volume is 1 (values 0-255 in logarithmic scale)
      @play_tick = ->(volume = 1) { `afplay -v #{volume} -q 1 ./tick.wav` }
      @play_tock = ->(volume = 1) { `afplay -v #{volume} -q 1 ./tock.wav` }
    else
      puts 'Sorry, no luck... Maybe try to install the ruby2d gem, running "gem install ruby2d -v 0.12.1"'
      @can_play = false
    end
    debug_info if debug_mode
  end

  # Testing the time to play tick.wav & tock.wav in this system (volume at zero, if possible)
  def times_test
    if can_play?
      ts = Time.now
      @play_tick.call(0)
      tm = Time.now
      @play_tock.call(0)
      tf = Time.now
      tick_secs = tm - ts
      tock_secs = tf - tm
      sound_secs = (tick_secs + tock_secs) / 2.0
      puts "Tick takes around #{sprintf('%.5f',tick_secs*1_000)} milliseconds to play."
      puts "Tock takes around #{sprintf('%.5f',tock_secs*1_000)} milliseconds to play."
      puts "The average is    #{sprintf('%.5f',sound_secs*1_000)} milliseconds"
      puts
      puts "The interval between sounds will be of around #{sprintf('%.5f',sleep_time(sound_secs)*1_000)} "\
           "milliseconds (dynamically adjusted)."
      puts
    end
  end

  def debug_info
    puts 'DEBUG mode is set'
    puts
    puts 'You ' + (@has_2d ? 'do' : 'do not') + ' seem to have the ruby2d gem!'
    puts
    times_test
  end

  def show_bpm_info
    # Note: it doesn't seem to be a clear consensus on the mapping between the BPM and the tempo names (markings)
    name = case @bpm
           when 0..24    then 'Larghissimo'
           when 25..39   then 'Grave'
           when 40..44   then 'Largo'
           when 45..60   then 'Lento'
           when 61..65   then 'Larghetto'
           when 66..75   then 'Adagio'
           when 76..108  then 'Andante'
           when 109..119 then 'Moderato'
           when 120..155 then 'Allegro'
           when 156..176 then 'Vivace'
           when 177..200 then 'Presto'
           when 201..250 then 'Prestissimo'
           end
    puts "Set at #{@bpm} beats per minute (#{name})."
    puts
  end

  def can_play?
    @can_play
  end

  # Calculates the silence interval (sleep):
  def sleep_time(sound_time, bpm = (@bpm || 90) )
    #   (sound_time + sleep_time)*bpm in 60 secs
    #   => sound*bmp + sleep*bmp = 60
    #   => sleep = (60 - sound*bpm)/bpm = 60/bpm - sound
    (60.0/bpm) - sound_time
  end

  def play
    if can_play?
      show_bpm_info
      puts 'Press Control & C to stop it...'
      begin
        while true do
          t0 = Time.now
          @play_tick.call
          sleep sleep_time(Time.now - t0)
          t0 = Time.now
          @play_tock.call
          sleep sleep_time(Time.now - t0)
        end
      rescue Interrupt
        puts
        puts 'Bye!'
      end
    else
      puts 'Sorry, play is not enabled'
    end
  end

  def self.play(args)
    Metronome.new(args).play
  end
end

Metronome.play(ARGV)

# Other execution options:

## 1. Object, all in one:
# Metronome.new(ARGV).play

## 2. Object, several play calls:
# m = Metronome.new(ARGV)
# m.play
# puts
# puts 'And again...'
# puts
# m.play
