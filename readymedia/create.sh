#!/bin/sh

CONTAINER_NAME="readymedia"
MOUNTS="/mnt"
IMAGE=$CONTAINER_NAME

if [ "$1" == "--build" ]
then
	podman build --file Containerfile --tag $IMAGE .
else
	# If ENV vars not set, ask user.
	[ -z $READYMEDIA_MAC ] && read -p "Enter MAC address for container: " READYMEDIA_MAC
	[ -z $READYMEDIA_IP ] && read -p "Enter IP address for container: " READYMEDIA_IP

	podman create --name $CONTAINER_NAME\
		--label io.containers.autoupdate=local\
		--restart unless-stopped\
		-v /var/cache/minidlna:/var/cache/minidlna:Z\
		-v $MOUNTS/music:/var/music\
		--network home\
		--mac-address $READYMEDIA_MAC\
		--ip $READYMEDIA_IP\
		-p 1900:1900/udp\
		-p 8200:8200/tcp\
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
fi
