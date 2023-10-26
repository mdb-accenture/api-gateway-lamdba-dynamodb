variable "jwtSecret" {
  description = "JWT Secret"
  sensitive   = true
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_s3_bucket" {
  description = "S3 Bucket for Zip"
}

local {
  routes = {
    "index" : {
      name : "index"
      http_verb : "GET"
      path = "/"
      policies : "logs:List*",
      resource : "arn:aws:logs:*:*:*"
    },
    "questions" : {
      name : "questions"
      http_verb : "GET"
      path = "/questions"
      policies : ["dynamodb:Scan"]
      resource : [aws_dynamodb_table.questions.arn]
      environment : {
        variables = {
          jwtSecret = var.jwtSecret
        }
      }
    },
    "question-post" : {
      name : "question-post"
      http_verb : "POST"
      path = "/question"
      policies : ["dynamodb:PutItem", "dynamodb:Scan"]
      resource : [aws_dynamodb_table.questions.arn]
    },
    "question-delete" : {
      name : "question-delete"
      http_verb : "DELETE"
      path = "/question"
      policies : ["dynamodb:DeleteItem"]
      resource : [aws_dynamodb_table.questions.arn]
    },
  }
}

