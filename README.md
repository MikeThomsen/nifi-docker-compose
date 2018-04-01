## Overview

Each of these provides two NiFi instances, one of which is meant to serve as a secondary instance to facilitate SiteToSite work.

* docker-compose-nifi-with-cockroachdb.yml - 3 node CockroachDB cluster
* docker-compose-es-mongo.yml - ElasticSearch and MongoDB.
* docker-compose-postgres.yml - PostgreSQL.
* docker-compose-pulsar-heron.yml - [Streaml.io sandbox](https://streaml.io/docs/getting-started) that provides Pulsar, Apache BookKeeper and Twitter Heron.
* docker-compose-sentinel.yml - Redis Sentinel all-in-one (Redis sentinel, master and slave).
* docker-compose-solrcloud.yml - Two node SolrCloud cluster w/ ZooKeeper.

## License

Some of the Docker Compose configurations are partly based on samples I found around the web. I don't assert any restrictions on the use of any of these Docker Compose configurations.

All `security_content` output is public domain.

All content in `templates` is Apache 2.0