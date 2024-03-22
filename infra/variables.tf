variable "region" {
  type    = string
  default = "us-east-2"
}

variable "cognito_admin_username" {
  type    = string
  default = "admin@point.com"
}

variable "point_db_secretsmanager_secret_name" {
  type    = string
  default = "mikes/db/db_credentials"
}