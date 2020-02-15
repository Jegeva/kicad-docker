#! /bin/bash
margs=""
if [ ! -z "$1" ]
then
    margs=${1/$HOME/\/root}
fi

xhost +local:root;
docker run -d --user $(id -u):$(id -g) \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
       -v /etc/passwd:/etc/passwd \
       -v $HOME:/home/$USER:rw \
       -v /usr/share/kicad:/usr/share/kicad kicad5.1 \
       kicad $margs

sleep 1

docker exec -it `docker ps|cut -d ' ' -f 1 |grep -v CONT` /bin/bash
