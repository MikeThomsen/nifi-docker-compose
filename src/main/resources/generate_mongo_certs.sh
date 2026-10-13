#!/bin/bash
# Regenerates the demo CA, per-node server certificates and the mongo_user client certificate in nifi_mongo/.
# Run from this directory: ./generate_mongo_certs.sh
# Public demo material only. Do not reuse these keys anywhere that matters.
set -euo pipefail

OUT=nifi_mongo
DAYS=3650
STORE_PASSWORD=${STORE_PASSWORD:-mongodemostorepass}
SERVERS="mongo1 mongo2 mongos mongocfg"

mkdir -p "$OUT"
openssl req -x509 -newkey rsa:2048 -nodes -days $DAYS -subj "/OU=NIFI/CN=localhost" \
    -keyout "$OUT/nifi-key.key" -out "$OUT/nifi-cert.pem"

# issue <name> <extra-san-or-empty> ; writes $OUT/<name>/<name>.key, <name>.pem and combined.pem
issue() {
    local name=$1 san=$2 dir="$OUT/$1"
    mkdir -p "$dir"
    openssl req -newkey rsa:2048 -nodes -subj "/OU=NIFI/CN=$name" -keyout "$dir/$name.key" -out "$dir/$name.csr"
    openssl x509 -req -in "$dir/$name.csr" -CA "$OUT/nifi-cert.pem" -CAkey "$OUT/nifi-key.key" -CAcreateserial \
        -days $DAYS -out "$dir/$name.pem" \
        -extfile <(printf 'extendedKeyUsage=serverAuth,clientAuth\n%s' "${san:+subjectAltName=$san}")
    cat "$dir/$name.key" "$dir/$name.pem" > "$dir/combined.pem"
    rm -f "$dir/$name.csr"
}

for s in $SERVERS; do
    issue "$s" "DNS:$s,DNS:localhost"
done
issue mongo_user ""

# Stores for the NiFi SSLContextService: the user's key pair plus a truststore holding the CA
openssl pkcs12 -export -in "$OUT/mongo_user/mongo_user.pem" -inkey "$OUT/mongo_user/mongo_user.key" \
    -certfile "$OUT/nifi-cert.pem" -name mongo_user -passout "pass:$STORE_PASSWORD" -out "$OUT/mongo_user/mongo_user.p12"
rm -f "$OUT/truststore.p12"
keytool -importcert -noprompt -alias nifi-ca -file "$OUT/nifi-cert.pem" \
    -keystore "$OUT/truststore.p12" -storetype PKCS12 -storepass "$STORE_PASSWORD"
rm -f "$OUT/nifi-cert.srl"
echo "Key store (mongo_user/mongo_user.p12) and trust store (truststore.p12) password: $STORE_PASSWORD"
