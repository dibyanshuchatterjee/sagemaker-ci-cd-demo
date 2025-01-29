module "map_mw_required_tags" {
  source          = "app.terraform.io/org/map-required-tags/aws"
  version         = "0.0.2"
  application_key = "demo-sagemaker"
  module_key      = var.module_key
  created_by      = var.created_by
  map_migrated    = "map_migrated"
}



resource "aws_security_group" "sagemakersecurity" {
  name                   = var.security_group_name
  vpc_id                 = var.vpc_id
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
