#!/bin/bash

# exit when any command fails
set -e

# Initialize shallow clones of submodules
git submodule --quiet update --init --recursive --single-branch --depth 1
[[ ${DEBUG:0} == 1 ]] && git submodule --quiet foreach 'git checkout -q -B dev origin/dev'

# Declare script constants
voib2lab_jwt_secret_path=./btestlab-rest/private/JWT_secret.key
voib2lab_tls_cert_path=./btestlab-webserver/private/Voib2lab_ECDSA_CERT.pem
voib2lab_tls_pk_path=./btestlab-webserver/private/Voib2lab_ECDSA_KEY.pem

# Generate TLS private key and self-signed certificate.
[[ ! -f $voib2lab_tls_pk_path ]] \
  && openssl ecparam -genkey -name prime256v1 -outform PEM -out $voib2lab_tls_pk_path \
  && chmod 644 $voib2lab_tls_pk_path
[[ $voib2lab_tls_cert_path -ot $voib2lab_tls_pk_path ]] \
  && openssl req -new -x509 -nodes -days 3650 -extensions v3_req -outform PEM \
    -config ./btestlab-webserver/openssl.conf \
    -key $voib2lab_tls_pk_path \
    -out $voib2lab_tls_cert_path \
  && chmod 644 $voib2lab_tls_cert_path

# Generate secret for signing JWT to access backend API.
[[ ! -f $voib2lab_jwt_secret_path ]] \
  && openssl rand -base64 -out $voib2lab_jwt_secret_path 32 \
  && chmod 644 $voib2lab_jwt_secret_path

# Finish early for non-root user
command -v sudo &> /dev/null && [[ $(id -u) != 0 ]] && sudo -v
command -v su &> /dev/null && [[ $(id -u) != 0 ]] && su -p
[[ $(id -u) != 0 ]] && exit 0

# Apply recommended system settings
# Swappines (https://www.mongodb.com/docs/manual/administration/production-notes/#std-label-set-swappiness)
if grep -q '^vm.swappiness' /etc/sysctl.conf ; then
  sudo sed -i '/^vm.swappiness/c\vm.swappiness=1' /etc/sysctl.conf
else
  echo -en '\nvm.swappiness=1\n' | sudo tee --append /etc/sysctl.conf > /dev/null
fi
sudo sysctl -p

# vi: et ts=2 sw=2