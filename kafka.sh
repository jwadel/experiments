###### KAFKA EXPERIMENT UTILITY SCRIPT ###### 
# 
# AUTHOR: 'Johnson O. Oluwadele'
# LOCATION: ./kafka
#
# DESCRIPTION: Setup Kafka with Zookeeper and MySQL on Docker Machine
#
# NOTE: Ensure you have enabled Hyper-V windows feature and created a virtual switch called "PrimaryVirtualSwitch"
# REF:  https://docs.microsoft.com/en-gb/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
#       https://docs.docker.com/machine/drivers/hyper-v/
#
# provision                     Creates a docker-machine using Hyper-V as driver
# up                            Spin up zookeeper, kafka and mysql containers
# down                          Remove all containers
# restart                       Restart all containers
# destroy                       Delete the docker-machine, all images and containers
#
# topic create [name] [partition]      Create a kafka topic
# topic delete [name]                  Delete a kafka topic
# topic list [name]                    List a kafka topic

function set_environment()
{ 
    eval $(docker-machine env confluent)
}

function provision()
{ 
    docker-machine create --driver hyperv --hyperv-virtual-switch PrimaryVirtualSwitch --hyperv-memory 6000 confluent
    set_environment
}

function destroy_machine()
{
    set_environment
    docker-machine rm confluent
}

function run_zookeeper()
{
    docker run -d \
        --net host \
        --name zookeeper \
        -e ZOOKEEPER_CLIENT_PORT=2181 \
        confluentinc/cp-zookeeper:4.1.0
}

function run_kafka()
{
    DOCKER_MACHINE_IP=$(docker-machine ip confluent)

    docker run -d \
        --net host \
        --name kafka \
        -e KAFKA_ZOOKEEPER_CONNECT=localhost:2181 \
        -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://$DOCKER_MACHINE_IP:29092 \
        -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
        confluentinc/cp-kafka:4.1.0
}

function run_mysql()
{
    HOST=$(docker-machine ip confluent)
    PORT=3306
    USER=root
    PASSWORD=secret
    ROOT_PASSWORD=secret

    docker run -d \
        --net host \
        --name mysql \
        -e MYSQL_USER=$USER \
        -e MYSQL_PASSWORD=$PASSWORD \
        -e MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
        -e MYSQL_ROOT_HOST=$HOST \
        mysql/mysql-server:latest
}

function run_containers()
{ 
    set_environment
    run_zookeeper
    run_kafka
    run_mysql
}

function remove_containers()
{ 
    set_environment
    docker rm -f zookeeper
    docker rm -f kafka
    docker rm -f mysql
}

function create_topic()
{
    docker run \
        --net=host \
        --rm confluentinc/cp-kafka:4.1.0 kafka-topics \
        --create --topic $1 \
        --partitions $2 --replication-factor 1 \
        --zookeeper localhost:2181
}

function delete_topic()
{
    docker run \
        --net=host \
        --rm confluentinc/cp-kafka:4.1.0 kafka-topics \
        --delete --topic $1 \
        --zookeeper localhost:2181
}

function list_topic()
{
    docker run \
        --net=host \
        --rm confluentinc/cp-kafka:4.1.0 kafka-topics \
        --describe --topic $1 \
        --zookeeper localhost:2181
}

### Command-line argument processing ###

COMMAND="$1"

if [[ $COMMAND = "provision" ]]; then 

    provision

elif [[ $COMMAND = "up" ]]; then
    
    run_containers

elif [[ $COMMAND = "down" ]]; then
    
    remove_containers

elif [[ $COMMAND = "destroy" ]]; then
 
    destroy_machine

elif [[ $COMMAND = "topic" ]]; then

    ACTION="$2"
    TOPIC="$3"

    set_environment 
    
    if [[ $ACTION = "create" ]]; then

        PARTITION="$4"
        create_topic $TOPIC $PARTITION

    elif [[ $ACTION = "delete" ]]; then

        delete_topic $TOPIC

    elif [[ $ACTION = "list" ]]; then

        list_topic $TOPIC

    fi
fi