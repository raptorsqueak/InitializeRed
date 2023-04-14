#>>>>> RAPTORSQUEAK TERMINAL CAPTURE >>>>>
# History file settings apply regardless of terminal capture
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# set up default history folder
mkdir -p "$HOME/.history"

alias caphist='cat ~/.history/*history*'
alias history='history 0'

# get the running process to determine what steps to take
running="$(ps -ocommand= -p $PPID | awk '{print $1}')"

if [ "$running" != "script" ]; then
    # set up script capture if wanted, defaults to no
    echo "Start script capture? <y/N>"
    read capture

    if [ "$capture" == "y" ] || [ "$capture" == "Y" ]; then
        export CAPTURE_DT=$(date +"%Y%m%d-%H%M%S")
        echo "Save location (default ~/.history):"
        if [ ${ZSH_VERSION} ]; then
            vared -c location
            export SHELL="/bin/zsh"
        fi
        if [ ${BASH_VERSION} ]; then
            read -e location
            export SHELL="bin/bash"
        fi
        # if not a directory or using the default set to default
        if [ ! -d "$location" ]; then
            location="$HOME/.history"
        fi
        export CAPTURE_DIR="$location"
        script --timing="${CAPTURE_DIR%%/}/$CAPTURE_DT-time.log" -f "${CAPTURE_DIR%%/}/$CAPTURE_DT-shell.log"
    fi
else
        # make sure it's just script that hits this portion
        if [ "$running" == "script" ]; then
            # change the history file to output terminal specific location
            HISTTIMEFORMAT="%s (%H:%M:%S): "
            #DT=$(date +"%Y%m%d-%H%M%S")
            HISTFILE="${CAPTURE_DIR%%/}/$CAPTURE_DT-history.log"
            echo "History file: $HISTFILE"
            
            #Set zsh and bash history parameters / options
            if [ ${ZSH_VERSION} ]; then
                precmd() { fc -W; }
                setopt appendhistory
                setopt extended_history
            fi
            if [ ${BASH_VERSION} ]; then
                export PROMPT_COMMAND="history -a;history-c;history -r"
            fi
        fi
fi
#<<<<< RAPTORSQUEAK HISTORY CAPTURE <<<<<