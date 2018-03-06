#!/bin/bash


# printf "# Each time the docker starts these will be overwritten\n\n" > /home/server/Zomboid/Server/pzserver.ini

# Install is actuall install or update
function install() {
  if [ "$PZ_UPDATE" == "1" ]; then
      ./pzserver update-lgsm
      ./pzserver update
  fi
  
  if [ "$PZ_FORCE_UPDATE" == "1" ]; then
      ./pzserver update-lgsm
      ./pzserver force-update
  fi

  if [ ! -d ./serverfiles ]; then
    ./pzserver update-lgsm
    ./pzserver auto-install
  fi
}


function start() {
  if [ ! -d ./serverfiles ]; then
    install
  else
     # trap exit signals
    trap stop INT SIGINT SIGTERM
    ./pzserver start
    sleep 10
    running
  fi
}

# stop the planet zombiod server
function stop() {
  ./pzserver stop
  # just to be sure wait 10 seconds
  sleep 10
  exit 0
}

# validate and update scripts and server
function update() {
	./pzserver update-functions
	./pzserver update
}

# running is for when running the docker to keep the image and server going
function running() {
  # attach to the tmux session
  # tmux set -g status off && tmux attach 2> /dev/null

  # if something fails while attaching to the tmux session then just wait
  while : ; do
    update
    sleep 3600
  done
}

if [ "$1" != "" ]; then
  if [ "$1" == "start" ]; then
    start
  fi
else
  install
fi