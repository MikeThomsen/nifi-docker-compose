## Overview

All of these run Apache NiFi 2.12.0. NiFi 2.x only serves HTTPS, so log in at `https://localhost:8443/nifi` with username `root` and password `rootrootroot` (accept the self-signed certificate warning).

* docker-compose-arangodb.yml - ArangoDB.
* docker-compose-nifi-with-cockroachdb.yml - 3 node CockroachDB cluster
* docker-compose-elasticsearch.yml - ElasticSearch.
* docker-compose-postgres.yml - PostgreSQL.
* docker-compose-sentinel.yml - Redis master, replica and sentinel (master name `mymaster`).
* docker-compose-solrcloud.yml - Two node SolrCloud cluster w/ ZooKeeper.
* docker-compose-ignite.yml - Apache Ignite support.
* docker-compose-registry-simple.yml -A simple NiFi Registry example without security enabled.
* docker-compose-janusgraph.yml - A configuration that connects NiFi with JanusGraph.

## License

Some of the Docker Compose configurations are partly based on samples I found around the web. I don't assert any restrictions on the use of any of these Docker Compose configurations.

All `security_content` output is public domain.
