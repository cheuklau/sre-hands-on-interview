# DevOps/SRE Hands-On Triage Interview Questions

## Introduction

This repository contains a series of hands-on interview questions for DevOps/SRE interview candidates. Each question simulates common scenarios that a DevOps/SRE might encounter when running a production environment. The interviewee candidate should be able to assess the situation using the provided monitoring tools, and triage the problem to get critical services back online. Follow-up questions should focus on monitoring, infrastructure changes or automation strategies to prevent future occurrences of the same problem.

## Scenario 1

### What does this test?

- Ability to read and understand a monitoring dashboard
- Familiarity with using a terminal 
- Use of basic Linux commandline tools e.g., `ssh`, `df`, `rm`, `cd`
- Basic understanding of filesystems and disk space

### Infrastructure Setting

Terraform spins up an AWS Ubuntu 16.04 EC2 instance with the following installed:
- A business-critical service
- Filebeat for monitoring application logs
- Logstash for parsing events from Filebeat
- Elasticsearch for indexing output from Logstash
- Kibana for displaying application logs in real time 

### Transient

The following series of events will occur:
1. For 300 seconds, `INFO` messages appear showing the number of documents processed by the business critical service
2. For 120 seconds, `WARN` messages appear showing storage is getting progressively full
3. A final `ERROR` message appears showing an out-of-space error
No additional logs after the final `ERROR` message indicates the process has died.

### Suggested Approach

The interviewee should perform the following:
1. Recognize that the business critical service died to an out-of-space filesystem
2. Recognize that a business critical service needs to be triaged immediately
3. SSH into machine via terminal with provided username and password
4. Run `df -h` to see which filesystem is full
    * The result will show `/run/user/1000` is at `100%`
5. Delete the file with `rm /run/user/1000/dummy.log`
6. Restart the process with `sudo python service.py` (command given by developers to restart the process)
7. Verify in monitoring that `INFO` logs are being generated again

### Follow-up Questions

1. What is a more robust way to run this service?
    * Run as a unit file using systemd which will handle restarts
    * Run as a container using a container orchestration platform
2. What are some possible improvements to the monitoring dashboard?
    * System resources e.g., CPU, memory and most importantly disk usage
3. How could we avoid this problem in the future?
    * Mount `/run` to a larger filesystem
    * Ask developer to avoid writing into `/run`
    * Monitor `/run` usage and automatically empty directory after reaching a certain size (e.g., `cronjob`)

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
    * The login username and password is `ec2-user` and `password`
