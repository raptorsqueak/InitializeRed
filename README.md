# InitializeRed

InitalizeRed is a colleciton of scripts that are useful for setting up a linux distribution install for Red Team activities.

## intialize.sh
Kicks off various initialization activities that need to occur after each new install of the chosen distribution.  Actions inlude:

  - Update and upgrade the distribution
  - Make sure initial dependencies are installed
  - Install python libraries
  - Enable the Metasploit database
  - Set up tools using PTF (https://github.com/trustedsec/ptf)
  - Set up terminal recording and history tracking

### Limitations
- Currently focused on Kali, but a more generic initialization is underway.

## terminal-history.sh
Prompts the user to start recording.  If yes, then terminal recording is started using script and a terminal specific history file is established.  Three files are created if recording, a history file, a script capture file, and a script timing file. Files created are prepended with the date and time the terminal was opened and placed in a chosen directory or in the default `$HOME/.history/`

During initialization this file is appended to .bashrc and .zshrc

### Limitations
- History for recorded sessions will no longer be available through the `history` command.  To help with command recall `caphist` is aliased to list the contents of all history files in the history directory.