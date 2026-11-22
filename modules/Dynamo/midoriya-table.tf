module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  count = var.dynamo_count 
  name     = "${var.dynamo_db_name}-${var.env}-${count.index +1 }"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
