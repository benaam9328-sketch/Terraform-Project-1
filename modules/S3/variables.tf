variable "s3_name" {

description = "Name of s3"
default = "terra-tilo-bucket"
type = string
}

variable "env" {
  description = "This holds env"
  type = string
}
variable "s3_count" {
  description = "This holds count"
  type = number
}
