#!/bin/sh

CONTAINER_NAME="readymedia"
MOUNTS="/mnt"
IMAGE=$CONTAINER_NAME

if [ "$1" == "--build" ]
then
	podman build --file Containerfile --tag $IMAGE .
else
	podman create --name $CONTAINER_NAME\
		--label io.containers.autoupdate=local\
		--restart unless-stopped\
		-v /var/cache/minidlna:/var/cache/minidlna:Z\
		-v $MOUNTS/music:/var/music\
		--network host\
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
