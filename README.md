# DevOps/SRE Hands-On Triage Interview Questions

## Introduction

This repository contains a series of hands-on interview questions for DevOps/SRE interview candidates. Each question simulates relatively common scenarios that a DevOps/SRE might encounter when running a production environment. The interview candidate should be able to assess the situation using the provided monitoring tools, and triage the problem to get critical services back online. Follow-up questions should focus on monitoring, infrastructure changes or automation strategies to prevent future occurrences of the same problem.

## Scenario 1

### What does this test?

- Ability to read and understand a monitoring dashboard
- Familiarity with using a terminal 
- Use of basic Linux commandline tools e.g., `ssh`, `df`, `rm`, `cd`
- Basic understanding of filesystems and disk space

### Infrastructure Setting

Terraform spins up an AWS Ubuntu 16.04 EC2 instance with the following installed:
- A business critical service
- Filebeat for monitoring the buisniess critical service logs
- Logstash for parsing the Filebeat events
- Elasticsearch for indexing the parsed events from Logstash
- Kibana for displaying log events in real time 

### Transient

The following series of events will occur:
1. For 300 seconds, `INFO` messages appear showing the number of documents processed by the business critical service
2. For 120 seconds, `WARN` messages appear showing storage is getting progressively full
3. A final `ERROR` message appears showing an out-of-space error
No additional logs after the final `ERROR` log indicates the process has died.

### Suggested Approach

The interviewee should perform the following:
1. Recognize that the business critical service died to a filesystem being full
2. Recognize that a business critical service needs to be triaged immediately
3. SSH into machine via terminal
    * Machine IP is the same as used to access Kibana (see if candidate can identify this)
    * `ssh -i <private key> ec2-user@<machine-ip>`
4. Perform `df -h` to see which filesystem is full
    * The result will show `/run/user/1000` is at `100%`
5. Delete the file with `rm /run/user/1000/dummy.log`
6. Restart the process with `sudo python service.py`
7. Verify in monitoring that `INFO` logs are back

### Follow-up Questions

1. What is a more robust way to run this service?
    * Run as a unit file using systemd which will handle restarts
    * Run as a container using a container orchestration platform
2. What are some possible improvements to the monitoring dashboard?
    * System resources e.g., CPU, memory
    * Disk usage of relevant filesystems
3. How could we avoid this problem in the future?
    * Mount `/run` to a larger filesystem
    * Ask developer to avoid writing into `/run`
    * Monitor `/run` usage and empty directory after reaching a certain size
4. What type of alerting  would you recommend for this dashboard?
    * No events for some given time period as this indicates the process is dead
    * `ERROR` or `WARN` logs observed for any given period as this indicates application-level problems
    * If disk space is above a certain threshold for a relevant filesystem

### Build Instructions

To set up the interview environment perform the following:
- `cd scenario_1`
- `./build.sh`
    * After Terraform is complete, it will output the EC2 public IP - copy this
- On a web browser go to `<ec2-public-ip>:5601` and perform the following in Kibana:
    * Go to `management`
    * Go to `saved objects`
    * Go to `import`
    * Select `kibana/export.ndjson`
    * Go to `dashboards`
    * Click `add` and select `log status timelion` and `last log`
- The above dashboard and an empty terminal constitutes the interview environment
    * The local directory should have the SSH private key
