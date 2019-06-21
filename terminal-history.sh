mkdir -p "$HOME/.history"
# set up script capture if wanted, defaults to no
running="$(ps -ocommand= -p $PPID | awk '{print $1}')"
if [ "$running" != "script" ]; then
	echo "Start script capture? <N>"
	read capture
	if [ "$capture" == "y" ] || [ "$capture" == "Y" ]; then
		script -f "$HOME/.history/$(date +"%Y%m%d_%H%M%S")_shell.log"
	fi
else
	# make sure it's just script that hits this portion
	if [ "$running" == "script" ]; then
		# change the history file to output to the same location and after
		# every command
		HISTFILE="$HOME/.history/$(date +"%Y%m%d_%H%M%S")_history.log"
		export PROMPT_COMMAND='history -a;history -c;history -r'
		# make the prompt a certain color so we know it's recording
		printf %b '\e]10;white\a\e]11;black\a'
	fi
fi
