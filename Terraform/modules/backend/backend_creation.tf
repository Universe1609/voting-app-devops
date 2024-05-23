#resource "aws_dynamodb_table" "todo-list-devsecops-table" {
#  name           = "todo-list-devsecops-table"
#  read_capacity  = 1
#  write_capacity = 1
#  hash_key       = "LockID"
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#
#  tags = {
#    "project" = "todo-list"
#  }
#}

#resource "aws_s3_bucket" "todo-list-devsecops-project" {
#  bucket = "todo-list-devsecops-project"
#  tags = {
#    "project" = "todo-list"
#  }
#}

