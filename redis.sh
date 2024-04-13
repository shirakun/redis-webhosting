#!/bin/bash
cd `dirname $0`

ps -ef | grep 'redis-server' | grep -v grep
if [ $? -ne 0 ]
then
    echo "redis starting."
    nohup /tmp/redis/redis-server /tmp/redis/redis.conf >> ./redis.log 2>&1 &
else
    echo "redis listening."
fi