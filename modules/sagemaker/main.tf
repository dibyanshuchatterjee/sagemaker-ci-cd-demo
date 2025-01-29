module "map_mw_required_tags" {
  source          = "app.terraform.io/uopx/map-required-tags/aws"
  version         = "0.0.2"
  application_key = "demo-sagemaker"
  module_key      = var.module_key
  created_by      = var.created_by
  map_migrated    = "map_migrated"
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lifecycle_config" {
  count    = var.lifecycle_config_name != "" ? 1 : 0
  name     = var.lifecycle_config_name
  on_start = filebase64(var.lifecyle_script_path)
}

resource "aws_sagemaker_notebook_instance" "notebook_instance" {
  count                 = var.ignore_code_repository  ? 1 : 0
  name                  = "demo-${var.sagemaker_instance_name}"
  role_arn              = var.role_arn
  instance_type         = var.instance_type
  subnet_id             = "subnet_id"
  security_groups       = var.security_group
  lifecycle_config_name = var.lifecycle_config_name != "" ? aws_sagemaker_notebook_instance_lifecycle_configuration.lifecycle_config[0].name : null
  tags                  = module.map_mw_required_tags.tags
}

# create the aws_sagemaker_code_repository resource only if ignore_code_repository is false and both repo_name and repo_url are provided.
# If ignore_code_repository is true or either of the repo_name or repo_url is null, the resource will not be created.
resource "aws_sagemaker_code_repository" "lscode" {
  count = var.ignore_code_repository  ? 0 : 1
  code_repository_name = var.repo_name
  git_config {
    repository_url = var.repo_url
    # we can make use of this same secret service arn for other project/pipeline as well.
    secret_arn     = "secret_arn"
  }
  tags            = module.map_mw_required_tags.tags
}


resource "aws_sagemaker_notebook_instance" "notebook_instance_with_code_repository" {
  # ensuring that the aws_sagemaker_notebook_instance resource is also conditional on the same conditions as the aws_sagemaker_code_repository resource.
  # aws_sagemaker_code_repository resource results in an empty tuple when var.ignore_code_repository is true. As a result, when you try to reference aws_sagemaker_code_repository.lscode[0].code_repository_name
  # in the aws_sagemaker_notebook_instance resource, it doesn't exist when ignore_code_repository is true.
  count                   = var.ignore_code_repository  ? 0 : 1
  name                    = "demo-${var.sagemaker_instance_name}"
  role_arn                = var.role_arn
  instance_type           = var.instance_type
  volume_size             = var.volume_size
  subnet_id               = "subnet_id"
  security_groups         = var.security_group
  tags                    = module.map_mw_required_tags.tags
  lifecycle_config_name   = var.lifecycle_config_name != "" ? aws_sagemaker_notebook_instance_lifecycle_configuration.lifecycle_config[0].name : null
  default_code_repository = aws_sagemaker_code_repository.lscode[0].code_repository_name
}
