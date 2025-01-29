module "demo_security_group" {
  source              = "./modules/security_group"
  security_group_name = "DFS_Sagemaker_Instance_SG"
  vpc_id              = var.vpc_id
  module_key          = "dfs_sagemaker_security_group"
}

module "demo_notebook_creation" {
  source                  = "./modules/sagemaker"
  sagemaker_instance_name = "demo-notebook"
  role_arn                = "arn:aws:iam::123456789:role/role_arn"
  vpc_id                  = var.vpc_id
  security_group          = [module.dfs_security_group.security_group_id]
  instance_type           = "ml.m5.4xlarge"
  module_key              = "sagemaker_instance"
  lifecycle_config_name   = "demo-autostop" # Autostops the instance by running a python file within jupyter instance
  lifecyle_script_path    = "./scripts/demo-config/autostop.sh"
  ignore_code_repository  = true
}

module "map_mw_required_tags" {
  source          = "app.terraform.io/org/map-required-tags/aws"
  version         = "0.0.2"
  application_key = "demo-sagemaker"
  module_key      = var.module_key
  created_by      = var.created_by
  map_migrated    = "map_migrated"
}



resource "aws_security_group" "sagemakersecurity" {
  name                   = "new_sec_grp_name"
  vpc_id                 = "vps_id"
  description            = "This group is created for AWS Sage Maker notebook for access within our VPN"
  revoke_rules_on_delete = true

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/9"]
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = module.map_mw_required_tags.tags
}