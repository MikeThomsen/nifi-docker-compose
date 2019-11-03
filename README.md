## Overview

Each of these provides two NiFi instances, one of which is meant to serve as a secondary instance to facilitate SiteToSite work.

* docker-compose-nifi-with-cockroachdb.yml - 3 node CockroachDB cluster
* docker-compose-elasticsearch.yml - ElasticSearch.
* docker-compose-postgres.yml - PostgreSQL.
* docker-compose-pulsar-heron.yml - [Streaml.io sandbox](https://streaml.io/docs/getting-started) that provides Pulsar, Apache BookKeeper and Twitter Heron.
* docker-compose-sentinel.yml - Redis Sentinel all-in-one (Redis sentinel, master and slave).
* docker-compose-solrcloud.yml - Two node SolrCloud cluster w/ ZooKeeper.
* docker-compose-ignite.yml - Apache Ignite support.
* docker-compose-mongo-ssl-shard.yml - MongoDB with SSL authentication and sharding.
* docker-compose-mongo-ssl.yml - MongoDB with SSL and simple replication.
* docker-compose-registry-secure.yml - A secure NiFi Registry example.
* docker-compose-registry-simple.yml -A simple NiFi Registry example without security enabled.

## Local Setup

1. Add `security_output/nifi-cert.pem` to your browser's certificate store as a trusted authority. Make sure to the trust on it as capable of validating both server and client certifcates.
2. Add `security_output/CN=initialAdmin,OU=NiFi.p12` as a user certificate in your browser, using the password in the `security_output/CN=initialAdmin,OU=NiFi.password` file.
3. Add a mapping for `127.0.0.1 demo.nifi` to `/etc/hosts` (`C:\Windows\system32\drivers\etc]hosts` on Windows).

## Mongo Shared Configuration for SSL

* Key Store Password: `YhAyfZLZoEiUBvxm3Y3OSa1xdNkpxhRVBQ1nG7ne/NU`
* Trust Store Password: `5/YbYUOqHvn3CcJm2mgx1LokLEFvcqqgQwTi4yN5k+I`

## Mongo ReplicaSet w/ SSL

To set up this demo, do the following:

1. `docker-compose -f docker-compose-mongo-ssl.yml up`
2. Upload the template `GetMongo_RS_w__SSL.xml` in NiFi and add it to the canvas.
3. `docker exec -it mongo1 mongo --ssl --sslPEMKeyFile /opt/mongo/mongo_user/mongo_user_combined.pem --sslCAFile /opt/mongo/nifi-cert.pem mongo1:27017`
4. Run the statement listed below:

```
rs.initiate(
  {
    _id : "myrs",
    members: [
      { _id : 0, host : "mongo1:27017" },
      { _id : 1, host : "mongo2:27017" }
    ]
  }
);
```

## MongoDB Sharded Collection with SSL

Docker Compose configuration file: `docker-compose-mongo-ssl-shard.yml`

Bring up the Docker Compose file and wait until all containers are running (could take up to 2 minutes).

Connect to the MongoDB configuration server using this command:

`docker exec -it mongocfg mongo --ssl --sslPEMKeyFile /opt/mongo/mongo_user/combined.pem --sslCAFile /opt/mongo/nifi-cert.pem mongocfg:27019`

Once the shell is up, run this configuration:

```
rs.initiate(
  {
    _id: "myrs",
    configsvr: true,
    members: [
      { _id : 0, host : "mongocfg:27019" }
    ]
  }
);
```

Now, connect to mongo1 with this command:

`docker exec -it mongo1 mongo --ssl --sslPEMKeyFile /opt/mongo/mongo_user/combined.pem --sslCAFile /opt/mongo/nifi-cert.pem mongo1:27018`

Run this configuration:

```
rs.initiate(
  {
    _id : "myrs_int",
    members: [
      { _id : 0, host : "mongo1:27018" },
      { _id : 1, host : "mongo2:27018" }
    ]
  }
);
```

At this point, both replica sets should be updated. Connect to the mongos service using this command:

`docker exec -it mongos mongo --ssl --sslPEMKeyFile /opt/mongo/mongo_user/combined.pem --sslCAFile /opt/mongo/nifi-cert.pem mongos:27017`

Run these commands to make `mongos` aware of the nodes in the replicaset:

```
sh.addShard("myrs_int/mongo1:27018")
sh.addShard("myrs_int/mongo2:27018")
```

Now, set up a test database like this:

```
sh.enableClustering("mystuff")
sh.shardCollection("mystuff.test", { msg: 1 });
```

You should now be able to insert a document like this into `mystuff.test`:

```
use mystuff

db.test.insert({ msg: "Hello, world" });
db.test.insert({ msg: "Buongiorno, mondo!"});
```

## License

Some of the Docker Compose configurations are partly based on samples I found around the web. I don't assert any restrictions on the use of any of these Docker Compose configurations.

All `security_content` output is public domain.

All content in `templates` is Apache 2.0
