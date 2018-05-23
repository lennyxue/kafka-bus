#!/bin/sh

APP_NAME=QuorumPeerMain
SERVER_PID="tpid"

pid=`cat $SERVER_PID | awk '{print $1}'`
pid=`ps -aef | grep $pid | grep $APP_NAME |grep -v grep | grep -v kill | awk '{print $2}' |grep $pid`
if [ ${pid} ]; then
    echo 'App is running.'
else
    echo 'App is NOT running.'
fi

