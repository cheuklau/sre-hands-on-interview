#!/bin/bash

#
# IMPORTANT: Set variables in vars.tf 
#

# Directories
TERRAFORMHOME='/Users/cheuklau/Documents/Code/Bosch/Devops_Interviews/scenario_1/terraform'

# Run Terraform
cd ${TERRAFORMHOME}
terraform init
terraform apply

echo '''
Finished setting up server. May take a few minutes for Kibana to becwome available.
Go to `<server-public-address>:5601` to access Kibana.
Import `kibana/export.ndjson` to get all saved Visualizations.
Create interview dashboard.
Start scenario by running `sudo python service.py` on the server.
Interview candidate should have a Kibana dashboard with:
1. log timelion chart
2. last log table for each log type
Interview candidate should also have access to a terminal with the following information:
1. path to pem key to ssh onto server
2. server public address
3. command to restart the service
'''