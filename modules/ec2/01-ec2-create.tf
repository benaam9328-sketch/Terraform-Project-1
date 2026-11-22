#Key

resource "aws_key_pair" "my_key_pair"{

	key_name = "${var.env}-terra-server-project"
	public_key = file("/home/ec2-user/Kenji/Project-1/terra-server-project.pub")
}


#Default VPC

resource"aws_default_vpc" "default" {}


#Security Grp

resource "aws_security_group" "my_security_grp"{

	name ="${var.env}-terra-server-security"
	vpc_id = aws_default_vpc.default.id 
	description = "Security group for terraserver"
}

#Inbound and outbound Rules

resource "aws_vpc_security_group_ingress_rule" "allow_http"{

	security_group_id = aws_security_group.my_security_grp.id
	cidr_ipv4 = "0.0.0.0/0"
	from_port = 80
  to_port = 80
	ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {

	security_group_id = aws_security_group.my_security_grp.id
	cidr_ipv4 = "0.0.0.0/0"
	ip_protocol = "-1"
}

# EC2 Instances
resource "aws_instance" "my_instance" {
   count = var.ec2_count

  ami           = var.ec2_ami_id # verify this exists in us-west-2
  instance_type = var.ec2_instance_type 

  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_grp.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.env}-${var.aws_instance_name}"
    Environment = var.env
      }
}
