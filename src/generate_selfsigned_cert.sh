#!/bin/bash

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

# Setup env
dotenv="${SCRIPT_PATH}/../.env"
if [ -f "$dotenv" ]; then
  set -o allexport
  source "$dotenv"
  set +o allexport
fi
# Verify required env variables
[ -z "$BTL_DOMAIN" ] && echo "Webserver's domain is not defined" && exit 1

# TLS file paths
crt="${SCRIPT_PATH}/../nginx/private/BTestLab_ECDSA_CERT.pem"
key="${SCRIPT_PATH}/../nginx/private/BTestLab_ECDSA_KEY.pem"


# Generate configuration
tls_conf=$(mktemp)
cat <<-EOF > $tls_conf
[req]
distinguished_name = req_distinguished_name
encrypt_key        = no
prompt             = no
x509_extensions    = v3_req

[req_distinguished_name]
CN = *.$BTL_DOMAIN

[v3_req]
basicConstraints = CA:true
extendedKeyUsage = serverAuth, clientAuth
keyUsage         = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
subjectAltName   = @alt_names

[alt_names]
DNS.1 = $BTL_DOMAIN
DNS.2 = *.$BTL_DOMAIN
EOF

# Generate private key and certificate
openssl ecparam -genkey -name prime256v1 -outform PEM -out $key \
  && openssl req -new -x509 -nodes -days 3650 -extensions v3_req -outform PEM \
    -config $tls_conf \
    -key $key \
    -out $crt \
  && chmod 644 $crt $key

# vi: et ts=2 sw=2