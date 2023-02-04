# Readymedia Container

## Firewalld Config

The container must use the host network mode so it can receive multicast.
This means that the ports Readymedia requires will not be opened by Podman.
To allow Readymedia (minidlna) through the firewall.

```sh
firewall-cmd --permanent --add-service minidlna
firewall-cmd --reload
```
