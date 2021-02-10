## Metronome

Very simple Terminal Metronome written in Ruby.

Tested only on MacOS 11.2 with Ruby 3.0.0 but it probably works in other systems and versions of Ruby.

It requires Ruby, which is usually pre-installed in most Mac or Linux machines. You can test if is present by running:

    ruby -v

It should display the version of Ruby you have, or err if you've none...

### Setup

If the sound files `tick.wav`, `tock.wav` are not present in the folder you install the program, you can use `setup.rb`to create them.

It also tries to install a sound library (Ruby gem), which would make the metronome a bit more precise (time-wise), than the MacOS player.

1. Run it:
    ./setup.rb
2. Test the sounds
    afplay ./tick.wav
    afplay ./tock.wav
3. You are done!

If you cannot execute `setup.rb`, it could be because the file does not have the execute flag set (`x` here):

    ls -l | awk '{print $1,$9}' | column -t 
      ...
      -rwxr-xr-x@ setup.rb
      ...

If that is the case, give it to it:

    chmod +x setup.rb

### Run it

Run the `met` command and pass over the "beats per minute" parameter (an Integer number), for example:

    ./met 60

The values allowed are from 24 to 250, and if no parameter is passed, it uses 90 bpm.

The command tests your system and calculates the time interval to be used between beats. This time interval could be different for different machines, and based how busy your computer is at the moment, but the difference is probably quite small (or so I hope).

### Options

An optional 2nd param (it requires the bpm param to have been set):

  -h:  Help on usage
  -d:  Debug mode, to show the interval time used and how is calculated

The debug mode displays times in milliseconds (1 second = 1,000 milliseconds).

###Credits

Initial idea found here, for a `bash` version: <https://community.unix.com/t/a-metronome/353150>
