#!/bin/bash

#Usage

if [[ $# -ne 1 ]]; then

    echo "Usage: get-elk.sh <container_name>"

#    container_name MUST include container type, for ex: core01, etc."

    exit 1
fi

container_name="$1"
#container_type=("core" "data")
#for i in "${container_type[@]}"; do
#    if [[ ${container_name} = *$i* ]]; then
#        break
#    else
#        echo "container_name MUST include container type"
#        exit 1
#    fi
#done


#Create if log folder doesn't exist

if [[ ! -d $HOME/load/${container_name} ]]; then

    echo "Creating log folder: $HOME/load/${container_name}"

    mkdir -p "$HOME/load/${container_name}"

fi

if [[ ! -d $HOME/config/ ]]; then

    echo "Creating configuration folder $HOME/config/"
    mkdir -p "$HOME/config/"

fi


#Pull if no configuration file

if [[ ! -f $HOME/config/logstash.conf ]]; then

    echo "Downloading logstash.conf into $HOME/config/"

    wget -q https://raw.githubusercontent.com/nttrieu/test/master/logstash.conf -P $HOME/config/

fi

#Pull if no docker-compose file

if [ ! -f $HOME/docker-compose.yml ]; then

    echo "Downloading docker-compose.yml"

    wget -q https://raw.githubusercontent.com/nttrieu/test/master/docker-compose.yml

fi

#Pull if no create-index-pattern.sh script

if [ ! -f $HOME/create-index-pattern.sh ]; then

    echo "Downloading create-index-pattern.sh"

    wget -q https://raw.githubusercontent.com/nttrieu/test/master/create-index-pattern.sh

fi


echo "To set VM setting, run: sudo echo 'vm.max_map_count=262144' >> /etc/sysctl.conf"
echo "Please copy ${container_name} logs to log folder and run: docker-compose up -d"
echo "Once indices are created, add index patterns via create-index-pattern.sh"
