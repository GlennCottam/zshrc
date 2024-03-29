# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Testing For Configs
# echo "Current Distro = " $zsh_distro
# echo "Package Manager = " $pkg_mgr
# echo "Is Root? = " $isroot
# echo "Toilet Font = " $toiletfont

# Auto Update:
zstyle ':omz:update' mode auto

# Plugins
plugins=(git)

# Programs
alias reload='clear && source ~/.zshrc'

RCCopy() {
    cd ~
    
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        rsync -avh --update --progress .zsh/.config/ ./
    else
        # Other systems (Linux, etc.)
        cp -uvr .zsh/.config/ ./
    fi
    
    chmod -R +rwx .zsh/.scripts/
}


RCinstall() {
	./install.sh
}

RCuninstall() {
  
  read -q VARIN\?"This will remove all configuration files assiociated with ZSHRC. Press any key to continue!"

  rm -rv ~/.zsh
  rm -rv ~/.oh-my-zsh/custom/themes/omz-themes

}

RCupdate() {

	echo "Updating ZSHRC"
	cd ~/.zsh/
	git pull origin main
	
	RCupdateThemes	
	RCCopy
}

RCupdateThemes() {
	echo "Updating Zshrc Themes"
	cd ~/.oh-my-zsh/custom/themes/omz-themes
	git pull https://$git_user:$git_key@github.com/$git_user/omz-themes.git
	reload
}

RCreset() {
	ehco "Resetting ZSHRC to git version"
	cd ~/.zsh/
	git reset --hard HEAD
	RCCopy
	cd ~
	reload
}

# Portianer script
PORTrun() {
	echo"Running Portainer"
	docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
	docker ps
}


# Diff 2 HTML
# Finds the difference between 2 files, and creates a file to easily view them.
diff2html() {
	ehco "DIFF2HTML..."
	echo "Finding Differences between $1, and $2"
	diff --color=always -y $1 $2 | aha --black --title "DIFF $1, $2" > diff.html
}

# Traceroute: NMAP must be installed
traceroute() {
	echo "Running Traceroute on: $1"
	sudo nmap -sn --traceroute $1
}

# Stupid little hack program I made (does nothing)
hack() {
  echo "Starting Hack..."
  sleep 1
  while [ 1 -eq 1 ]
  do
    echo probing memory: $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM
    sleep 0.01
  done
}

installOMZ() {
	echo "Installing Oh-My-ZSH"
	sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Service Adjustment
ServiceRestart() {
	echo "Restarting Service $1"
	$isroot service $1 restart && $isroot service status
}

# stupid code to print Big Sad in big letters
BigSad() {
  clear
  echo -e ${BBLUE}
  toilet -t -f future "Big Sad"
  echo -e ${NORMAL}
}

# Prints out text and sends it to file
toiletExport() {
  echo "\`\`\`" > $2
  toilet -t -f future $1 >> $2
  echo "\`\`\`" >> $2
}

# Lists open ports of current machine
ListOpenPorts() {
	echo "Open Ports"
	netstat -lntu
}

# Creates a script (used it in class)
createScript()
{
  script auto.script
}

# Creates tarball using a specific specification
tarball()
{
  # tar zcf $1.tgz $1
  tar -jcvf $1.tar.bz2 $2
  ls
}

weather() {
	curl http://wttr.in
}

watch_weather() {
	watch -c -n 60 "curl http://wttr.in"
}

alias sysmon='watch -n 0.5 ~/.zsh/.scripts/sys_status.sh'


# Compressed Extractor
# Got this oneline from someone else. Uncompresses various file types automatically
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.xz)    tar xf $1      ;;
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# Easy Read Man Pages
# More code I got online to help with reading man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#netinfo - shows network information for your system
netinfo ()
{
"--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
ifconfig | grep inet
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
"---------------------------------------------------"
}

#dirsize - finds directory sizes and lists them for the current directory
dirsize ()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm -rf /tmp/list
}

# default editor
export EDITOR=vim

# define color to additional file types
export LS_COLORS=$LS_COLORS:"*.wmv=01;35":"*.wma=01;35":"*.flv=01;35":"*.m4a=01;35"

# Alias' have been created for Ubuntu / Debian
# The proper packages will need to be installed for some to work
#Alias'
alias h="cd ~"
alias ls='ls -la'
alias rmr='rm -r'
alias update='$isroot $pkg_mgr update && $isroot $pkg_mgr upgrade -y && RCupdate'
alias py='clear && python3'
alias back='cd ..'
alias home='cd ~/ && clear && reload'
alias svim='$isroot vim'
alias ppa='$isroot add-apt-repository'
alias root='$isroot -i'
alias install='$isroot $pkg_mgr install -y'
alias openports='netstat -lntu'
alias diskuse='ncdu -x -q /'


alias dhcprenew='dhcpclient -r & ifconfig'

# Service Control
alias service_disable='$isroot systemctl disable --now'
alias service_enable='$isroot systemctl enable --now'
alias service_status='$isroot systemctl list-unit-files --type=service'
alias service_enabled='$isroot systemctl list-unit-files --type=service --state=enabled'

alias monitor='bashtop'

# Toilet Info
alias toilet_fonts='ls /usr/share/figlet'

# ----------------------------------

# Docker Alias'
# Generated by ChatGPT

# List all containers (running and stopped)
alias dockerps='docker ps -a'

# List all images
alias dockerimages='docker images'

# Build an image from a Dockerfile
alias dockerbuild='docker build -t'

# Start a container with an interactive shell
alias dockersh='docker run -it'

# Start a container and map a port to the host
alias dockerrun='docker run -p'

# Stop a running container
alias dockerstop='docker stop'

# Remove a container
alias dockerrm='docker rm'

# Remove an image
alias dockerimagrm='docker rmi'

# Display container logs
alias dockerlogs='docker logs'

# Execute a command inside a running container
alias dockere='docker exec'

# Display information about a container
alias dockerinspect='docker inspect'

# ----------------------------------

# Distro Upgrade
# Generated by ChatGPT

Update() {
	# check if apt-get is available
	if command -v apt-get &> /dev/null
	then
	  # update all packages using apt-get
	  sudo apt-get update
	  sudo apt-get upgrade -y
	# check if dnf is available
	elif command -v dnf &> /dev/null
	then
	  # update all packages using dnf
	  sudo dnf upgrade -y
	# check if yum is available
	elif command -v yum &> /dev/null
	then
	  # update all packages using yum
	  sudo yum update -y
	# check if zypper is available
	elif command -v zypper &> /dev/null
	then
	  # update all packages using zypper
	  sudo zypper refresh
	  sudo zypper update -y
	else
	  # if no package manager is found, display an error message
	  echo "Error: No package manager found on this system."
	fi
	
	RCupdate
}

# Dependencies
# - Lynx
# - Screenfetch
# - Toilet
# - Lolcat
# - aha

# Fonts:
# ascii12.tlf     bigascii9.tlf  circle.tlf   future.tlf  mono9.tlf      smascii9.tlf   smmono12.tlf
# ascii9.tlf      bigmono12.tlf  emboss.tlf   letter.tlf  pagga.tlf      smblock.tlf    smmono9.tlf
# bigascii12.tlf  bigmono9.tlf   emboss2.tlf  mono12.tlf  smascii12.tlf  smbraille.tlf  wideterm.tlf
