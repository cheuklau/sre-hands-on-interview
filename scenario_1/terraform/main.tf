########################################################################
# Set up AWS VPC, subnets, security groups
########################################################################
module "aws" {

  source = "./modules/aws"

  AWS_ACCESS_KEY = "${var.AWS_ACCESS_KEY}"
  AWS_SECRET_KEY = "${var.AWS_SECRET_KEY}"
  AWS_REGION = "${var.AWS_REGION}"
  PATH_TO_PUBLIC_KEY = "${var.PATH_TO_PUBLIC_KEY}"

}

########################################################################
# Set up service
########################################################################
module "service" {

  source = "./modules/service"

  AMIS = "ami-082b5a644766e0e6f"
  KEY_NAME = "${module.aws.KEY_NAME}"
  SECURITY_GROUP_ID = "${module.aws.SECURITY_GROUP_ID}"
  SUBNET = "${module.aws.SUBNET}"
  SUBNET_NUM = "1"
  PATH_TO_PRIVATE_KEY = "${var.PATH_TO_PRIVATE_KEY}"
  AWS_ACCESS_KEY = "${var.AWS_ACCESS_KEY}"
  AWS_SECRET_KEY = "${var.AWS_SECRET_KEY}"
  AWS_REGION = "${var.AWS_REGION}"

}