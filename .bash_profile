# append home path of nodeJS
NODE_JS_HOME="/opt/node"
PATH="$PATH:$NODE_JS_HOME/bin"
export PATH

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# color for ls
alias ls='ls --color=auto'

let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

# get the load averages
read one five fifteen rest < /proc/loadavg

# credits: http://www.raspberrypi.org/phpBB3/viewtopic.php?f=26&t=23440&p=293093&hilit=bash_profile#p293093
echo "$(tput setaf 2)
   .~~.   .~~.    `date +"%A, %e %B %Y, %r"`
  '. \ ' ' / .'   `uname -srmo`$(tput setaf 1)
   .~ .~~~..~.
  : .~.'~'.~. :   Uptime.............: ${UPTIME}
 ~ (   ) (   ) ~  Memory.............: `cat /proc/meminfo | grep MemFree | awk {'print $2'}`kB (Free) / `cat /proc/meminfo | grep MemTotal | awk {'print $2'}`kB (Total)
( : '~'.~.'~' : ) CPU Temperature....: `exec -- /opt/vc/bin/vcgencmd measure_temp | cut -c "6-9"`
 ~ .~ (   ) ~. ~  Load Averages......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)
  (  : '~' :  )   Running Processes..: `ps ax | wc -l | tr -d " "`
   '~ .~~~. ~'    IP Addresses.......: `/sbin/ifconfig eth0 | /bin/grep "inet addr" | /usr/bin/cut -d ":" -f 2 | /usr/bin/cut -d " " -f 1` and `wget -q -O - http://icanhazip.com/ | tail`
       '~'        NodeJS.............: `node -v`
                  Free Disk Space SD.: `df -Pk | grep -E '/root' | awk '{ print $4 }' | awk -F '.' '{ print $1 }'`k on /root

$(tput sgr0)"


