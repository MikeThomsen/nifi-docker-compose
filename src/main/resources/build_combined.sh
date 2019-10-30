#!/bin/bash

openssl pkcs12 -in $1.p12 -nocerts -out temp.key
openssl rsa -in temp.key -out $1.key
openssl pkcs12 -in $1.p12 -clcerts -nokeys -out $1.pem
cat $1.key $1.pem > combined.pem
rm -fv temp.key