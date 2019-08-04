############################################################################
#
# Output variables required for other modules
#
############################################################################

output "KEY_NAME" {
  value = "${aws_key_pair.mykeypair.key_name}"
}

output "SECURITY_GROUP_ID" {
  value = "${aws_security_group.interview-sg.id}"
}

output "SUBNET" {
  value = "${aws_subnet.main-public.id}"
}