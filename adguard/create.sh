#!/bin/sh

CONTAINER_NAME="adguardhome"
MOUNTS="/opt/adguard"
IMAGE="docker.io/adguard/adguardhome:latest"

podman create --name $CONTAINER_NAME\
	--label io.containers.autoupdate=registry\
	--restart unless-stopped\
	-v $MOUNTS/work:/opt/adguardhome/work:Z\
	-v $MOUNTS/conf:/opt/adguardhome/conf:Z\
	--network home\
	--ip $ADGUARD_IP\
	--cap-add=NET_RAW\
	-p 53:53/tcp -p 53:53/udp\
	-p 67:67/udp -p 68:68/tcp -p 68:68/udp\
	-p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp\
	--hostname $CONTAINER_NAME\
	$IMAGE

if [ "$1" == "--service" ]
then
	podman generate systemd \
		--new --name $CONTAINER_NAME \
		> /etc/systemd/system/$CONTAINER_NAME.service

	systemctl enable --now $CONTAINER_NAME
else
	podman start $CONTAINER_NAME
fi
