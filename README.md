# Basic Quick Experiments With Technologies

- ## KAFKA EXPERIMENT (Utility Script)  

  **Location:** [Kafka](./kafka)

  **Description:** Setup Kafka with Zookeeper and MySQL on Docker Machine

  **Note:** 
	- Install and use Git-Bash instead of Windows Command Prompt (a)
	- Install Docker for Windows (b)
	- Enable Hyper-V windows feature (c) and create a virtual switch called "PrimaryVirtualSwitch" (d)

  **References:** 
	- (a) http://www.techoism.com/how-to-install-git-bash-on-windows/
	- (b) https://www.docker.com/community-edition#/download
    - (c) https://docs.microsoft.com/en-gb/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
    - (d) https://docs.docker.com/machine/drivers/hyper-v/
  
  **Commands:**
     ```
    provision                             Creates a docker-machine using Hyper-V as driver

    up                                    Spin up zookeeper, kafka and mysql containers

    down                                  Remove all containers

    restart                               Restart all containers

    destroy                               Delete the docker-machine, all images and containers

    topic create [name] [partition]       Create a kafka topic

    topic delete [name]                   Delete a kafka topic

    topic list [name]                     List a kafka topic
    ```
	
  **Example Usage:**
     ```
    ./kafka.sh provision
	./kafka.sh topic create TestTopic 10
    ```
	
	