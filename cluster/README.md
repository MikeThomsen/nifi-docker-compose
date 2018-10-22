# Cluster Test

## Setup

* 1 ZooKeeper instance.
* 3 NiFi nodes
* 1 MongoDB instance.

Add three hosts to `/etc/hosts` mapped to `127.0.0.1`:

* node1.nifi
* node2.nifi
* node3.nifi

## Run

* Do a complete build of NiFi 1.8.0-SNAPSHOT (ie latest pre-release builder).
* From $NIFI_ROOT `cd nifi-docker/nifi-dockermaven`
* `mvn clean install -Pdocker`
* `docker-compose up`
