#!/bin/sh
rm -f tpid
sh bin/zookeeper-server-start.sh -daemon config/zookeeper.properties >> /opt/logs/zookeeper/console-`date +%F-%H%M%S`.log &
echo $! > tpid

echo Start Success!
