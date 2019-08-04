############################################################################
#
# Required variables 
#
############################################################################

variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" { default = "us-west-2" }

variable "PATH_TO_PUBLIC_KEY" { default = "~/.ssh/mykey.pub" }

variable "PATH_TO_PRIVATE_KEY" { default = "~/.ssh/mykey" }
