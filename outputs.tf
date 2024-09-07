output "api_url" {
  value = "https://${aws_api_gateway_rest_api.crud_api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_deployment.crud_deployment.stage_name}/items"
}