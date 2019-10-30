#!/bin/bash
grep -i pass nifi.properties
keytool -importkeystore -srckeystore keystore.jks -destkeystore $1 -srcstoretype JKS -deststoretype PKCS12 -destkeypass changeme