resource "aws_s3_bucket" "my_s3" {
count = var.s3_count
bucket = "${var.s3_name}-${var.env}-${count.index + 1}"

tags = {
  Name = "${var.s3_name}-${count.index +1}"
  Environment = var.env
}
}

