############################################################################
#
# Create server
#
############################################################################
resource "aws_instance" "service" {
  ami = "${var.AMIS}"
  instance_type = "t2.large"
  key_name = "${var.KEY_NAME}"
  count = 1
  vpc_security_group_ids = ["${var.SECURITY_GROUP_ID}"]
  subnet_id = "${var.SUBNET}"
  associate_public_ip_address = true
  tags {
    Name = "service"
    Terraform = "true"
  } 
}

############################################################################
#
# Configure service
#
############################################################################
resource "null_resource" "service" {

  # Establish connection to the server
  connection {
    type = "ssh"
    user = "ec2-user"
    host = "${aws_instance.service.public_ip}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

  # We need the service instance spun up first
  depends_on = [ "aws_instance.service" ]

  # Provision the files to set up elasticsearch
  provisioner "file" {
    source = "${path.module}/files/elasticsearch.repo"
    destination = "/home/ec2-user/elasticsearch.repo"
  }

  # Provision the files to set up Filebeat
  provisioner "file" {
    source = "${path.module}/files/filebeat.yml"
    destination = "/home/ec2-user/filebeat.yml"
  }

  # Provision the files to set up Kibana
  provisioner "file" {
    source = "${path.module}/files/kibana.repo"
    destination = "/home/ec2-user/kibana.repo"
  }
  provisioner "file" {
    source = "${path.module}/files/kibana.yml"
    destination = "/home/ec2-user/kibana.yml"
  }

  # Provision the files to set up Logstash
  provisioner "file" {
    source = "${path.module}/files/logstash.repo"
    destination = "/home/ec2-user/logstash.repo"
  }
  provisioner "file" {
    source = "${path.module}/files/logstash.conf"
    destination = "/home/ec2-user/logstash.conf"
  }

  # Provision the files to initialize and run the service
  provisioner "file" {
    source = "${path.module}/files/initialize.py"
    destination = "/home/ec2-user/initialize.py"
  }
  provisioner "file" {
    source = "${path.module}/files/service.py"
    destination = "/home/ec2-user/service.py"
  }

  # Provision the files to start Elastic stack and initialize service
  provisioner "file" {
    source = "${path.module}/scripts/run.sh"
    destination = "/home/ec2-user/run.sh"
  }

  # Execute script to start services
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/run.sh",
      "./run.sh"
    ]
  }
}