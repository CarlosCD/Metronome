## Metronome

Very simple Terminal Metronome written in Ruby.

Tested only on MacOS 11.2 with Ruby 3.0.0 but it probably works in other systems and versions of Ruby.

Ruby comes usually pre-installed in most Mac or Linux machines. You can verify that it is present by running:

    ruby -v

It should show the version of Ruby you have, or err if you've none...

### Setup

If the sound files `tick.wav`, and `tock.wav` are not present in the folder you install the program, you can use `setup.rb`to create them.

It also tries to install a ruby library (gem) to make the metronome a bit more precise (time-wise), than using the MacOS player.

1. Run it:  
    ./setup.rb
2. Test the sounds  
    afplay ./tick.wav  
    afplay ./tock.wav  
3. You are done!

If you cannot execute `setup.rb`, it could be because the file does not have the execute flag set (`x`):

    ls -l | awk '{print $1,$9}' | column -t 
      ...
      -rwxr-xr-x@ setup.rb
      ...

If that is the case, give it to it:

    chmod +x setup.rb

### Run it

Run the `met` command and pass over the "beats per minute" parameter (an Integer number), for example:

    ./met 60

The values allowed are from 24 to 250. If no parameter is passed it uses 90 bpm.

The command tries to adapt to your system, dynamically calculating the time interval to be used between beats. The main reason is that the interval could be different for different machines, and change based how busy your computer is at the moment... the difference is probably quite small, but small things demand care too.

### Options

An optional 2nd param (requires the bpm param to have been set) codifies a flag:

    -h:  help on how to use it.
    -d:  debug mode, to show the interval time used and how is calculated

The debug mode displays times in milliseconds (1 second = 1,000 milliseconds).

### Credits and links

- Idea for a `bash` metronome: <https://community.unix.com/t/a-metronome/353150>
- MacOS afplay man page: <https://ss64.com/osx/afplay.html>
- Documentation of a Ruby Gem, "ruby2d", to play WAV audio files (plus many other capabilities): <https://www.ruby2d.com/learn/audio/>
  + Ruby2d gem code: <https://github.com/ruby2d/ruby2d>
  + Pull request to control audio volume: <https://github.com/ruby2d/ruby2d/pull/170>
  + My fork of the original gem, last version, plus the volume's pull request: <>
