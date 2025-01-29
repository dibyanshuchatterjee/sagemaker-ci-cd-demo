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