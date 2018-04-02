## Overview

Each of these provides two NiFi instances, one of which is meant to serve as a secondary instance to facilitate SiteToSite work.

* docker-compose-nifi-with-cockroachdb.yml - 3 node CockroachDB cluster
* docker-compose-es-mongo.yml - ElasticSearch and MongoDB.
* docker-compose-postgres.yml - PostgreSQL.
* docker-compose-pulsar-heron.yml - [Streaml.io sandbox](https://streaml.io/docs/getting-started) that provides Pulsar, Apache BookKeeper and Twitter Heron.
* docker-compose-sentinel.yml - Redis Sentinel all-in-one (Redis sentinel, master and slave).
* docker-compose-solrcloud.yml - Two node SolrCloud cluster w/ ZooKeeper.

## Local Setup

1. Add `security_output/nifi-cert.pem` to your browser's certificate store as a trusted authority. Make sure to the trust on it as capable of validating both server and client certifcates.
2. Add `security_output/CN=initialAdmin,OU=NiFi.p12` as a user certificate in your browser, using the password in the `security_output/CN=initialAdmin,OU=NiFi.password` file.
3. Add a mapping for `127.0.0.1 demo.nifi` to `/etc/hosts` (`C:\Windows\system32\drivers\etc]hosts` on Windows).

## License

Some of the Docker Compose configurations are partly based on samples I found around the web. I don't assert any restrictions on the use of any of these Docker Compose configurations.

All `security_content` output is public domain.

All content in `templates` is Apache 2.0