FROM apache/nifi:1.5.0

USER root

ADD authorizations.xml /opt/nifi/nifi-1.5.0/conf/authorizations.xml

ADD users.xml /opt/nifi/nifi-1.5.0/conf/users.xml

RUN chown nifi /opt/nifi/nifi-1.5.0/conf/*.xml

USER nifi
