# kafka集群搭建

## 1. 服务器基本信息
ip地址 | 安装服务
- | :-: |
10.0.0.1 | kafka_2.11-1.1.0
10.0.0.2 | kafka_2.11-1.1.0
10.0.0.3 | kafka_2.11-1.1.0

## 2. 环境信息
系统版本：Centos 7

jdk版本：jdk-8u171

## 3. 安装jdk(省略)

## 4. 配置Zookeeper
```
vi kafka_2.11-1.1.0/config/zookeeper.properties
```

### 4.1 修改以下内容
```
maxClientCnxns=60
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data/zookeeper/data
dataLogDir=/data/logs/zookeeper
clientPort=2181
server.1=10.0.0.1:2888:3888
server.2=10.0.0.2:2888:3888
server.3=10.0.0.3:2888:3888
```

```
2888表示zookeeper程序监听端口，3888表示zookeeper选举通信端口。
```
### 4.2 创建数据和日志文件夹
```
mkdir -p /data/zookeeper/data
mkdir -p /data/logs/zookeeper
```

### 4.3 生成myid文件
注意三台机器该配置文件应该不一致，该id表明每个节点唯一身份id
#### 10.0.0.1
```
echo "1" >/data/zookeeper/data/myid ##生成ID，这里需要注意， myid对应的zookeeper.properties的server.ID，比如第二台zookeeper主机对应的myid应该是2
```

#### 10.0.0.2
```
echo "2" >/data/zookeeper/data/myid
```

#### 10.0.0.3
```
echo "3" >/data/zookeeper/data/myid
```

## 5. 启动Zookeeper
```
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
```

## 6. 配置Kafka
```
vi kafka_2.11-1.1.0/config/server.properties
```
### 6.1 修改如下配置
```
# 第一段 写到 10.0.0.1上server.properties配置
broker.id=0
listeners=PLAINTEXT://10.0.0.1:9092
zookeeper.connect=10.0.0.1:2181,10.0.0.2:2181,10.0.0.3:2181
delete.topic.enable=true
log.dir=/data/kafka-logs
log.retention.hours=168
message.max.bytes=5242880
replica.fetch.max.bytes=5242880

# 第二段 写到 10.0.0.2上server.properties配置
broker.id=1
listeners=PLAINTEXT://10.0.0.2:9092
zookeeper.connect=10.0.0.1:2181,10.0.0.2:2181,10.0.0.3:2181
delete.topic.enable=true
log.dir=/data/kafka-logs
log.retention.hours=168
message.max.bytes=5242880
replica.fetch.max.bytes=5242880

# 第三段 写到 10.0.0.3上server.properties配置
broker.id=2
listeners=PLAINTEXT://10.0.0.3:9092
zookeeper.connect=10.0.0.1:2181,10.0.0.2:2181,10.0.0.3:2181
delete.topic.enable=true
log.dir=/data/kafka-logs
log.retention.hours=168
message.max.bytes=5242880
replica.fetch.max.bytes=5242880
```

### 6.2 创建数据和日志文件夹
```
mkdir -p /data/kafka-logs
```

## 7. 启动kafka（三台）
```
bin/kafka-server-start.sh -daemon config/server.properties
```

## 8. 创建 TOPIC

使用 kafka-topics.sh 创建单分区单副本的 topic test：

```
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
``` 

查看 topic 列表：
```
bin/kafka-topics.sh --list --zookeeper localhost:2181
```
## 9. 产生消息

使用 kafka-console-producer.sh 发送消息：
```
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
mark
```

## 10. 消费消息

使用 kafka-console-consumer.sh 接收消息并在终端打印：

```
bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
```