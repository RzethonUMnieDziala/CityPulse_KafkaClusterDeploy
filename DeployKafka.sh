#!/bin/bash
 
cd kafka_2.11-1.0.0
 
nodesCounter=3
 
zookeeperPropertiesName=config/zookeeper.properties
>$zookeeperPropertiesName
echo dataDir=/tmp/zookeeper >> config/zookeeper.properties
echo clientPort=2181 >> config/zookeeper.properties
echo maxClientCnxns=0 >> config/zookeeper.properties
echo delete.topic.enable=true >> config/zookeeper.properties
sh -x bin/zookeeper-server-start.sh config/zookeeper.properties &> zookeper.log &
for node in 1 2 3
do
let port=node+9092
serverPropertiesName=config/server$node.properties
>$serverPropertiesName
echo broker.id=$node >> $serverPropertiesName
echo listeners=PLAINTEXT://:$port >> $serverPropertiesName
echo log.dirs=/tmp/kafka-logs$node >> $serverPropertiesName
echo zookeeper.connect=localhost:2181 >> $serverPropertiesName
mkdir -p /tmp/kafka-logs$node
sh -x bin/kafka-server-start.sh config/server$node.properties &> server$node.log &
done
sh -x bin/kafka-topics.sh --delete --topic humidity --zookeeper localhost:2181 &> create.topic.log &
sh -x bin/kafka-topics.sh --delete --topic electricity --zookeeper localhost:2181 &> create.topic.log &
sh -x bin/kafka-topics.sh --delete --topic water --zookeeper localhost:2181 &> create.topic.log &
sh -x bin/kafka-topics.sh --delete --topic temperature --zookeeper localhost:2181 &> create.topic.log &
sh -x bin/kafka-topics.sh --delete --topic pollution --zookeeper localhost:2181 &> create.topic.log &
sh -x bin/kafka-topics.sh --create --topic humidity --zookeeper localhost:2181 --partitions 3 --replication-factor 3 &> create.topic.log &
sh -x bin/kafka-topics.sh --create --topic electricity --zookeeper localhost:2181 --partitions 3 --replication-factor 3 &> create.topic.log &
sh -x bin/kafka-topics.sh --create --topic water --zookeeper localhost:2181 --partitions 3 --replication-factor 3 &> create.topic.log &
sh -x bin/kafka-topics.sh --create --topic temperature --zookeeper localhost:2181 --partitions 3 --replication-factor 3 &> create.topic.log &
sh -x bin/kafka-topics.sh --create --topic pollution --zookeeper localhost:2181 --partitions 3 --replication-factor 3 &> create.topic.log 
