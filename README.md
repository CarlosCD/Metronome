## Metronome

Very simple Terminal Metronome written in Ruby.

Tested on MacOS with Ruby 3.0.0 & 3.2.0, but it probably works in other systems and versions of Ruby.

Ruby comes usually pre-installed in most Mac or Linux machines. You can verify that it is present by running:

    ruby -v

It should show the version of Ruby you have, or err if you've none...

### Setup

If the sound files `tick.wav`, and `tock.wav` are not present in the folder you install the program, you can
use `setup.rb`to create them.

It also tries to install a ruby library (gem) to make the metronome a bit more precise (time-wise), than using
the MacOS player.

1. Run it:  
    ./setup.rb
2. Test the sounds  
    afplay ./tick.wav  
    afplay ./tock.wav  
3. You are done!

### Run it

Run the `met` command and pass over the "beats per minute" parameter (an Integer number), for example:

    ./met.rb 60

The values allowed are from 24 to 250. If no parameter is passed it uses 90 bpm.

The command tries to adapt to your system, dynamically calculating the time interval between beats you
initially set. This continuous adjustment is necessary due to differences between machines, and fluctuations
based on how busy your computer is at a certain moment... this difference is probably quite small, but small
things matter too.

### Options

An optional 2nd param (requires the bpm param to have been set) codifies a flag:

    -h:  help on how to use it.
    -d:  debug mode, to show the interval time used and how is calculated

The debug mode displays times in milliseconds (1 second = 1,000 milliseconds).

### Credits and useful links

- A `bash` metronome: <https://community.unix.com/t/a-metronome/353150>
- MacOS afplay man page: <https://ss64.com/osx/afplay.html>
- Ruby Gem "ruby2d", to play WAV audio files (plus many other capabilities):
  + Documentation: <https://www.ruby2d.com/learn/audio/>
  + Code: <https://github.com/ruby2d/ruby2d>
