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

## License

Some of the Docker Compose configurations are partly based on samples I found around the web. I don't assert any restrictions on the use of any of these Docker Compose configurations.

All `security_content` output is public domain.

All content in `templates` is Apache 2.0
