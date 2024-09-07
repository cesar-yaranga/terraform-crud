provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "crud_bucket" {
  bucket = "crud-s3-bucket-example"
}

resource "aws_s3_object" "crud_db_file" {
  bucket = aws_s3_bucket.crud_bucket.id
  key    = "db.json"
  content = <<EOF
{
  "items": []
}
EOF
}