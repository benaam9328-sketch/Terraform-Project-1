locals {

 env = { 
   dev = {
     ec2_count = 1
    s3_count = 1
    dynamo_count = 1
   }

   stg = {
     ec2_count = 2
    s3_count = 1
    dynamo_count = 1
   }

   prod = {
    ec2_count = 3
    s3_count = 2
    dynamo_count = 2
   }
 }
  # count = {
  #   dev = 1
  #   stg =2
  #   prod = 3
  # }
current = lookup(local.env, terraform.workspace, local.env["dev"])
}


module "ec2" {
  source = "./modules/ec2"
  env = terraform.workspace
  ec2_count = local.current.ec2_count
}

module "S3" {
  source = "./modules/S3"
  env = terraform.workspace
  s3_count = local.current.s3_count
}
module "Dynamo" {
  source = "./modules/Dynamo"
  env = terraform.workspace
  dynamo_count = local.current.dynamo_count
}
