#!/bin/sh
rm -f tpid
sh bin/kafka-server-start.sh -daemon config/server.properties >> /opt/logs/kafka-logs/console-`date +%F-%H%M%S`.log &
echo $! > tpid

echo Start Success!

