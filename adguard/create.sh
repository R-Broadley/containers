#!/bin/sh

CONTAINER_NAME="adguardhome"
MOUNTS="/opt/adguard"
IMAGE="docker.io/adguard/adguardhome:latest"

podman create --name $CONTAINER_NAME\
	--label io.containers.autoupdate=registry\
	--restart unless-stopped\
	-v $MOUNTS/work:/opt/adguardhome/work:Z\
	-v $MOUNTS/conf:/opt/adguardhome/conf:Z\
	-p 53:53/tcp -p 53:53/udp\
	-p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp\
	$IMAGE

podman generate systemd \
	--new --name $CONTAINER_NAME \
	> /etc/systemd/system/$CONTAINER_NAME.service

systemctl enable --now $CONTAINER_NAME
