# experiments

Basic Experiment With Technologies

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
