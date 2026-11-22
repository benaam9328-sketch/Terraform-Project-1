variable "aws_instance_name" {

description = "Name of instance"
default = "Terra-tilo"
type = string
}

variable "env" {
  description = "Set value of env"
  type = string

}

variable "ec2_ami_id" {
  description = "ami id"
  default = "ami-09bf9dfeeb1e9adbc"
  type =string 
}

variable "ec2_instance_type" {
  description = "t2.nano"
  default = "t2.nano"
  type =string
}

variable "ec2_count" {
  description = "Count"
  type = number
}


