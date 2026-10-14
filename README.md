## Overview

All of these run Apache NiFi 2.12.0. NiFi 2.x only serves HTTPS, so log in at `https://localhost:8443/nifi` with username `root` and password `rootrootroot` (accept the self-signed certificate warning).

* docker-compose-arangodb.yml - ArangoDB.
* docker-compose-nifi-with-cockroachdb.yml - 3 node CockroachDB cluster
* docker-compose-elasticsearch.yml - ElasticSearch.
* docker-compose-opensearch.yml - OpenSearch with TLS (demo certificates) and password protection, plus OpenSearch Dashboards. Log in as `admin` / `Demo_Search-4271xZ`; use `https://localhost:9200` with `curl -k`.
* docker-compose-mongodb.yml - Three member MongoDB replica set with authentication and [Mongoku](https://github.com/huggingface/mongoku). See [MongoDB and Mongoku](#mongodb-and-mongoku).
* docker-compose-postgres.yml - PostgreSQL.
* docker-compose-sentinel.yml - Redis master, replica and sentinel (master name `mymaster`).
* docker-compose-solrcloud.yml - Two node SolrCloud cluster w/ ZooKeeper.
* docker-compose-ignite.yml - Apache Ignite support.
* docker-compose-registry-simple.yml -A simple NiFi Registry example without security enabled.
* docker-compose-janusgraph.yml - A configuration that connects NiFi with JanusGraph.

## Building and Running

The compose files use Maven properties for image versions (see `pom.xml`). Run `mvn clean package` to substitute them, then run a file from `target/classes`, or from the unzipped `target/nifi-docker-compose-dev.zip`:

```
docker compose -f docker-compose-mongodb.yml up -d
docker compose -f docker-compose-mongodb.yml down -v
```

Several files publish the same ports (8443 for NiFi and its container name `nifi`), so run one at a time.

## MongoDB and Mongoku

`docker-compose-mongodb.yml` starts a three member replica set (`rs0`), Mongoku and NiFi.

* Mongoku: `http://localhost:3100`, already connected to the replica set.
* MongoDB user: `admin` / `admin` (authentication database `admin`).
* Connection string from inside the compose network, such as a NiFi processor: `mongodb://admin:admin@mongo1:27017,mongo2:27017,mongo3:27017/?replicaSet=rs0&authSource=admin`
* Connection string from the host (only `mongo1` is published, on 27017): `mongodb://admin:admin@localhost:27017/?authSource=admin&directConnection=true`

The members authenticate to each other with a keyfile whose value is written in the compose file. It is a demo value and not secret, so do not reuse it for real data.

MongoDB is pinned to 8.2 (`mongo.version` in `pom.xml`) because 8.0, 8.3 and 9.0 refuse to start on Linux kernels 6.19 and newer (SERVER-121912).

## License

Some of the Docker Compose configurations are partly based on samples I found around the web. I don't assert any restrictions on the use of any of these Docker Compose configurations.
