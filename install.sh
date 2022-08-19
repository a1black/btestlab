#!/bin/bash

# Run OS setup script
PROJECT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
grep -qi '^name="ubuntu' /etc/os-release && . "$PROJECT_PATH/ubuntu_setup.sh"

# exit when any command fails
set -e

# Initialize shallow clones of submodules
git submodule --quiet update --init --recursive --single-branch --depth 1
[[ ${DEBUG:0} == 1 ]] && git submodule --quiet foreach 'git checkout -q -B dev origin/dev'

# Declare script constants
voib2lab_jwt_secret_path=./btestlab-rest/private/JWT_SECRET.key
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

# vi: et ts=2 sw=2
