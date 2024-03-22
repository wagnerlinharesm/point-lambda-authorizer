provider "aws" {
  region = var.region
}

data "aws_cognito_user_pools" "point-user-pool" {
  name = "point"
}

data "aws_cognito_user_pool_clients" "point-user-pool-app-client" {
  user_pool_id = data.aws_cognito_user_pools.point-user-pool.ids[0]
}

resource "aws_iam_role" "point_lambda_authorizer_role" {
  name               = "point_lambda_authorizer_role"
  assume_role_policy = file("policy/lambda_assume_role_policy.json")
}

resource "aws_iam_role_policy" "point_lambda_authorizer_policy" {
  name   = "point_lambda_authorizer_policy"
  role   = aws_iam_role.point_lambda_authorizer_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "cognito-idp:AdminGetUser"
        Resource  = "arn:aws:cognito-idp:us-east-2:644237782704:userpool/us-east-2_3HJlRalTj"
      },
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:GetSecretValue",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "point_lambda_authorizer" {
  function_name = "point_lambda_authorizer"
  handler       = "app/lambda_function.handler"
  runtime       = "python3.11"
  role          = aws_iam_role.point_lambda_authorizer_role.arn

  filename = "lambda_function.zip"

  source_code_hash = filebase64sha256("lambda_function.zip")

  depends_on = [
    aws_iam_role.point_lambda_authorizer_role
  ]

  environment {
    variables = {
      COGNITO_CLIENT_ID    = data.aws_cognito_user_pool_clients.point-user-pool-app-client.client_ids[0],
      COGNITO_USER_POOL_ID = data.aws_cognito_user_pools.point-user-pool.ids[0],
      COGNITO_ADMIN_USERNAME = var.cognito_admin_username,
      DB_HOST = "point-db.cqivfynnpqib.us-east-2.rds.amazonaws.com",
      POINT_DB_USERNAME           = local.point_db_credentials["username"]
      POINT_DB_PASSWORD           = local.point_db_credentials["password"]
    }
  }
}

data "aws_secretsmanager_secret" "point_db_secretsmanager_secret" {
  name = var.point_db_secretsmanager_secret_name
}

data "aws_secretsmanager_secret_version" "point_db_secretsmanager_secret_version" {
  secret_id = data.aws_secretsmanager_secret.point_db_secretsmanager_secret.id
}

locals {
  point_db_credentials  = jsondecode(data.aws_secretsmanager_secret_version.point_db_secretsmanager_secret_version.secret_string)
}


