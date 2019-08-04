#!/bin/bash

# Update and install Java 8
sudo yum -y update
sudo yum -y install java-1.8.0-openjdk

# Download and install Filebeat
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.2.0-x86_64.rpm
sudo rpm -vi filebeat-7.2.0-x86_64.rpm
sudo mv /home/ec2-user/filebeat.yml /etc/filebeat
sudo chown root: /etc/filebeat/filebeat.yml

# Download and install Logstash
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo mv /home/ec2-user/logstash.repo /etc/yum.repos.d/
sudo yum -y install logstash
sudo mv /home/ec2-user/logstash.conf /etc/logstash/

# Download and install Elasticsearch
sudo mv /home/ec2-user/elasticsearch.repo /etc/yum.repos.d/
sudo yum -y install elasticsearch

# Download and install Kibana
sudo mv /home/ec2-user/kibana.repo /etc/yum.repos.d/
sudo yum -y install kibana
sudo mv /home/ec2-user/kibana.yml /etc/kibana/

# Note: start elastic stack and service in Terraform
sudo systemctl start elasticsearch.service
sudo nohup /usr/share/logstash/bin/logstash -f /etc/logstash/logstash.conf &
sudo systemctl start filebeat.service
sudo systemctl start kibana.service

# Run the initialize script so Kibana dashboard has indices
sudo python initialize.py