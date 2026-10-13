#!/bin/bash
# Regenerates the demo CA and the PKCS12 key/trust stores used by the secure registry and integration test samples
# (for_registry/<node>/keystore.p12 and truststore.p12). Run from this directory: ./generate_registry_certs.sh
# Public demo material only. Do not reuse these keys anywhere that matters.
set -euo pipefail

OUT=for_registry
DAYS=3650
STORE_PASSWORD=${STORE_PASSWORD:-registrydemostorepass}
NODES="demo.nifi prov.nifi registry.nifi"

mkdir -p "$OUT"
openssl req -x509 -newkey rsa:2048 -nodes -days $DAYS -subj "/OU=NiFi/CN=nifi-ca" \
    -keyout "$OUT/nifi-ca.key" -out "$OUT/nifi-ca.pem"

for node in $NODES; do
    dir="$OUT/$node"
    mkdir -p "$dir"
    openssl req -newkey rsa:2048 -nodes -subj "/OU=NiFi/CN=$node" -keyout "$dir/$node.key" -out "$dir/$node.csr"
    openssl x509 -req -in "$dir/$node.csr" -CA "$OUT/nifi-ca.pem" -CAkey "$OUT/nifi-ca.key" -CAcreateserial \
        -days $DAYS -out "$dir/$node.pem" \
        -extfile <(printf 'extendedKeyUsage=serverAuth,clientAuth\nsubjectAltName=DNS:%s,DNS:localhost\n' "$node")
    openssl pkcs12 -export -in "$dir/$node.pem" -inkey "$dir/$node.key" -certfile "$OUT/nifi-ca.pem" \
        -name "$node" -passout "pass:$STORE_PASSWORD" -out "$dir/keystore.p12"
    rm -f "$dir/truststore.p12"
    keytool -importcert -noprompt -alias nifi-ca -file "$OUT/nifi-ca.pem" \
        -keystore "$dir/truststore.p12" -storetype PKCS12 -storepass "$STORE_PASSWORD"
    rm -f "$dir/$node.csr" "$dir/$node.key"
done
rm -f "$OUT/nifi-ca.srl" "$OUT/nifi-ca.key"
echo "Key store and trust store password: $STORE_PASSWORD"
