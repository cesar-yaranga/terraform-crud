resource "aws_api_gateway_rest_api" "crud_api" {
  name        = "crud-s3-api"
  description = "API for Lambda CRUD with S3"
}

resource "aws_api_gateway_resource" "crud_resource" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  parent_id   = aws_api_gateway_rest_api.crud_api.root_resource_id
  path_part   = "items"
}

resource "aws_api_gateway_method" "crud_method_post" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.crud_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "crud_method_get" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.crud_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "crud_method_put" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.crud_resource.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "crud_method_delete" {
  rest_api_id   = aws_api_gateway_rest_api.crud_api.id
  resource_id   = aws_api_gateway_resource.crud_resource.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "crud_integration_post" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.crud_resource.id
  http_method = aws_api_gateway_method.crud_method_post.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.crud_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "crud_integration_get" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.crud_resource.id
  http_method = aws_api_gateway_method.crud_method_get.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.crud_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "crud_integration_put" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.crud_resource.id
  http_method = aws_api_gateway_method.crud_method_put.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.crud_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "crud_integration_delete" {
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  resource_id = aws_api_gateway_resource.crud_resource.id
  http_method = aws_api_gateway_method.crud_method_delete.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.crud_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crud_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "crud_deployment" {
  depends_on = [
    aws_api_gateway_integration.crud_integration_post,
    aws_api_gateway_integration.crud_integration_get,
    aws_api_gateway_integration.crud_integration_put,
    aws_api_gateway_integration.crud_integration_delete
  ]
  rest_api_id = aws_api_gateway_rest_api.crud_api.id
  stage_name  = "prod"
}