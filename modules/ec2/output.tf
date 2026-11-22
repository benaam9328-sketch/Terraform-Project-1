output "ec2_public_ip" {

value = aws_instance.my_instance[*].public_ip
}

output "ec2_type" {
value = aws_instance.my_instance[*].instance_type
}

#output "ec2-public_ip_existing" {
# value = aws_instance_my_existing_instance.public_ip
#}



