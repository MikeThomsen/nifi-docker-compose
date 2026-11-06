## Overview

All of these run Apache NiFi 2.12.0. NiFi 2.x only serves HTTPS, so log in at `https://localhost:8443/nifi` with username `root` and password `rootrootroot` (accept the self-signed certificate warning).

* docker-compose-arangodb.yml - ArangoDB.
* docker-compose-nifi-with-cockroachdb.yml - 3 node CockroachDB cluster
* docker-compose-elasticsearch.yml - ElasticSearch.
* docker-compose-opensearch.yml - OpenSearch with TLS (demo certificates) and password protection, plus OpenSearch Dashboards. Log in as `admin` / `Demo_Search-4271xZ`; use `https://localhost:9200` with `curl -k`.
* docker-compose-kafka-native.yml - Three node Kafka cluster (KRaft, `apache/kafka-native`) with [Kafka UI](https://github.com/kafbat/kafka-ui). See [Kafka and Kafka UI](#kafka-and-kafka-ui).
* docker-compose-mongodb.yml - Three member MongoDB replica set with authentication and [Mongoku](https://github.com/huggingface/mongoku). See [MongoDB and Mongoku](#mongodb-and-mongoku).
* docker-compose-neo4j.yml - Neo4j Community Edition. See [Neo4j](#neo4j).
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

## Kafka and Kafka UI

`docker-compose-kafka-native.yml` starts three Kafka nodes (each is both broker and controller), Kafka UI and NiFi. It uses the GraalVM native Kafka image, which starts faster and uses less memory but is experimental upstream and meant for development and testing only. For the regular JVM image, change the image to `apache/kafka:${kafka.version}`; nothing else needs to change.

* Bootstrap servers from inside the compose network, such as a NiFi processor: `kafka1:29092,kafka2:29092,kafka3:29092`
* Bootstrap servers from the host: `localhost:9092,localhost:9093,localhost:9094`
* Internal topics and new topics default to replication factor 3, with `min.insync.replicas=2`.
* Kafka UI: `http://localhost:8080`. Login is off by default. To require the username `admin` and password `admin`:

```
KAFKA_UI_AUTH=LOGIN_FORM docker compose -f docker-compose-kafka-native.yml up -d
```

  Set `KAFKA_UI_USERNAME` and `KAFKA_UI_PASSWORD` to use different credentials.

## Neo4j

`docker-compose-neo4j.yml` starts Neo4j Community Edition and NiFi.

* Neo4j user: `neo4j` / `neo4jneo4j`
* Neo4j Browser: `http://localhost:7474`
* Bolt URL from inside the compose network, such as NiFi's `Neo4JCypherClientService`: `bolt://neo4j:7687`
* Bolt URL from the host: `bolt://localhost:7687`

NiFi 2.x does not include the graph components. To use `Neo4JCypherClientService` and `ExecuteGraphQuery`, download these NARs from Maven Central (group `org.apache.nifi`, same version as NiFi), put them in an `extensions` directory next to the compose file, and then start the stack:

* `nifi-graph-client-service-api-nar`
* `nifi-neo4j-cypher-service-nar`
* `nifi-graph-nar`

```
mkdir -p extensions
for a in nifi-graph-client-service-api-nar nifi-neo4j-cypher-service-nar nifi-graph-nar; do
  curl -fLo extensions/$a-2.12.0.nar https://repo1.maven.org/maven2/org/apache/nifi/$a/2.12.0/$a-2.12.0.nar
done
```

Neo4j clustering is an Enterprise Edition feature, so this file runs a single instance.

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
