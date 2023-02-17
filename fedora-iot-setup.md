# Fedora IOT Set Up

## Network

Setup static IP address and Podman MACVLAN network:

```sh
CONNECTION=$(nmcli --get-values general.connection device show eth0)
GATEWAY=<gateway address>
nmcli connection modify "$CONNECTION" ipv4.addresses <IP address in CIDR format>
nmcli connection modify "$CONNECTION" ipv4.gateway $GATEWAY
nmcli connection modify "$CONNECTION" ipv4.dns "9.9.9.9,1.1.1.1"
nmcli connection modify "$CONNECTION" ipv4.method manual

podman network create -d macvlan  --subnet=<subnet in CIDR format>  --gateway=$GATEWAY -o parent=eth0 home
```

## Auto OS Update

Run `sudo systemctl edit --force --full rpm-ostreed-upgrade-reboot.service` and add the following to the file.

```
[Unit]
Description=rpm-ostree upgrade and reboot
ConditionPathExists=/run/ostree-booted

[Service]
Type=simple
ExecStart=/usr/bin/rpm-ostree upgrade --reboot
```

Run `sudo systemctl edit --force --full rpm-ostreed-upgrade-reboot.timer` and add the following to the file.

```
[Unit]
Description=rpm-ostree upgrade and reboot trigger
ConditionPathExists=/run/ostree-booted

[Timer]
OnCalendar=Mon..Sun 04:30

[Install]
WantedBy=timers.target
```
