#!/bin/bash
#------------------------------------------------------------------------------
# get updated
#------------------------------------------------------------------------------
apt update
apt -y full-upgrade
apt autoremove
apt-get install -y python git sudo locate vim pip tcpdump net-tools

#------------------------------------------------------------------------------
# powershell
#------------------------------------------------------------------------------
# dependencies
apt -y install curl gnupg apt-transport-https
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/powershell.list
apt update
# get powershell
apt -y install powershell

#------------------------------------------------------------------------------
# Python things
#------------------------------------------------------------------------------
pip install --upgrade pip
# OT libraries
pip install cpppo
pip install configparser
pip install git+https://github.com/dmroeder/pylogix
pip install pycom

# General libraries used by other tools
pip install pipenv
pip install python-ldap

#------------------------------------------------------------------------------
# Metasploit
#------------------------------------------------------------------------------
# get postgres up and running for metasploit
sudo update-rc.d postgresql enable
service postgresql restart
msfdb delete
msfdb init

#------------------------------------------------------------------------------
# Git helper
#------------------------------------------------------------------------------
BASE="~/Tools"
mkdir -p "$BASE"
gogitit(){
	# $1 = git repo to pull
	# $2 = directory to put it into locally
	GITDIR="$(echo $(basename $1) | sed -e 's/\.git//g')"
	if [ "$2" = "" ]; then
		DIR="$BASE/$GITDIR"
	else
		DIR="$BASE/$2/$GITDIR"
	fi
	
	if [ ! -d "$DIR" ]; then
		git clone "$1" "$DIR"
	else
		(cd "$DIR" && git pull;)
	fi	
}

#------------------------------------------------------------------------------
# PTF Repo
#------------------------------------------------------------------------------
gogitit "https://github.com/trustedsec/ptf.git" "Setup"
# Move over custom ptf files
cp -r ptf "$BASE/Setup/ptf/config/ptf"
(cd "$BASE/Setup/ptf/" && echo -en "use modules/install_update_all\nyes\n" | python ptf)
echo
echo "** DONE **"
echo "PTF is built and ready to use."

#------------------------------------------------------------------------------
# Terminal History
#------------------------------------------------------------------------------
cat terminal-history.sh >> ~/.bashrc