# RCEHelper
Simple script to help with reverse shell stuff. With this you can save some time and avoid typing the same commands over and over again to get a reverse shell, spawn a pty, upgrade it to a fully interactive one, etc.

Just choose the configs you want and the desired command will be set as your clipboard

# Features
## Reverse shell via
  - bash
  - python
  - python3
  - perl
  - nc
  - php

## PTY shell and stabilize it via
  - script
  - python3
  - python
  - perl
  - sh

## Upload files via
  - python
  - php
  - ruby
  - ngrok


# Usage: ./rceHelper.sh [option]
 See more options with --help or -h
	

Usage: ./rceHelper.sh [options]

Options:

pty - Spawn a pty shell

reverse/rev - Get a reverse shell

upload/up - Upload a file via HTTP
  
  
  
# Tips:
Add some keybinds to your system config so that you can run commands fastly.

I use these:

- `CTRL + ALT + SHIFT + R` is binded to the command `terminator -x "bash ~/MyCodes/tools/rceHelper.sh rev"`
- `CTRL + ALT + SHIFT + P` is binded to the command `terminator -x "bash ~/MyCodes/tools/rceHelper.sh pty"`
- `CTRL + ALT + SHIFT + U` is binded to the command `terminator -x "bash ~/MyCodes/tools/rceHelper.sh up"`

For another terminal emulator, this can be helpful:
https://unix.stackexchange.com/questions/205217/how-to-hold-terminal-open-excepting-gnome-terminal
