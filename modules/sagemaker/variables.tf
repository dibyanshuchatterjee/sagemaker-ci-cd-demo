variable "sagemaker_instance_name" {}
variable "role_arn" {}
variable "instance_type" {}
variable "security_group" {
  type = list(any)
}
variable "module_key" {}
variable "created_by" {
  default = "email"
}
variable "vpc_id" {}
variable "lifecycle_config_name" {
  default = ""
}
variable "lifecyle_script_path" {
  default = ""
}

variable "repo_name" {
     default = ""
}

variable "repo_url" {
    default = ""
}

variable "ignore_code_repository" {
    default = false
    type = bool
}



variable "volume_size" {
    default = "5"
}