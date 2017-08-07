#!/bin/sh

VPN_USER="$1"
VPN_PASSWORD="$2"

if [ -z "$VPN_USER" ] || [ -z "$VPN_PASSWORD" ]; then
  echo "Usage: $0 username password" >&2
  echo "Example: $0 jordi rtdxt132" >&2
  exit 1
fi

case "$VPN_USER" in
  *[\\\"\']*)
    echo "VPN credentials must not contain any of these characters: \\ \" '" >&2
    exit 1
    ;;
esac

SHARED_SECRET=$(cut -d'"' -f2 /etc/ipsec.secrets)
echo "Shared secret: $SHARED_SECRET"

VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
echo "Password for user is: $VPN_PASSWORD"

echo '"'$VPN_USER'"' l2tpd '"'$VPN_PASSWORD'"' '*' >> /etc/ppp/chap-secrets
echo $VPN_USER:$VPN_PASSWORD_ENC:xauth-psk >> /etc/ipsec.d/passwd
