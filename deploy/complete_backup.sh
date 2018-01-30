#!/bin/bash

CASS_DATA_PATH=/var/lib/cassandra/data

mkdir keyspace_backup schemas

echo 'Clearing old snapshots'
nodetool clearsnapshot

nodetool flush

echo 'Backing up schema and keyspaces'
ls $CASS_DATA_PATH | grep -v system* > dbs.log

while read keyspace
do
    cp -rf $CASS_DATA_PATH/$keyspace keyspace_backup/
    cqlsh -e "DESC $keyspace" > schemas/$keyspace.schema
done < dbs.log

echo 'creating zip'

tar -cvf complete_cassandra_bakup_$(date +%Y%m%d) keyspace_backup schemas dbs.log