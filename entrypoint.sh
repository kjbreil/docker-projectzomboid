#!/bin/bash


printf "# Each time the docker starts these will be overwritten\n\n" > /home/server/lgsm/config-lgsm/pzserver/common.cfg

printf "ip="%s"\n" "$IP" >> /home/server/lgsm/config-lgsm/pzserver/common.cfg
printf "adminpassword="%s"\n" "$ADMIN_PASSWORD" >> /home/server/lgsm/config-lgsm/pzserver/common.cfg
printf "servicename="%s"\n" "$SERVER_NAME" >> /home/server/lgsm/config-lgsm/pzserver/common.cfg


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
  if [ ! -d ./Zomboid ]; then
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
  echo "Stopping Server"
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
  if [ "$1" == "shell" ]; then
    /bin/bash
  fi
else
  install
fi