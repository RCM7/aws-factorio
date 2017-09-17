output "api_invoke_url" {
  description = "The URL to be used to make API calls"
  value = "${aws_api_gateway_deployment.factorio.invoke_url}"
}

output "api_key" {
  description = "The API Key"
  value = "${aws_api_gateway_api_key.my_factorio_key.value}"
}

output "auth_token" {
  description = "The Auth Token to set as environment variable of the lambda function. Used as (very) simple authentication method for now"
  value = "${var.lambda_auth_token}"
}
