resource "aws_api_gateway_rest_api" "factorio" {
  name        = "factorio"
  description = "This is an API to perform start and stop actions on factorio"
}

resource "aws_api_gateway_resource" "start" {
  rest_api_id = "${aws_api_gateway_rest_api.factorio.id}"
  parent_id   = "${aws_api_gateway_rest_api.factorio.root_resource_id}"
  path_part   = "start"
}

resource "aws_api_gateway_method" "start_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.factorio.id}"
  resource_id   = "${aws_api_gateway_resource.start.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = "${aws_api_gateway_rest_api.factorio.id}"
  resource_id             = "${aws_api_gateway_resource.start.id}"
  http_method             = "${aws_api_gateway_method.start_post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.start_factorio.arn}/invocations"
}

resource "aws_api_gateway_method_response" "start_post" {
  rest_api_id = "${aws_api_gateway_rest_api.factorio.id}"
  resource_id = "${aws_api_gateway_resource.start.id}"
  http_method = "${aws_api_gateway_integration.lambda.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.factorio.id}"
  resource_id = "${aws_api_gateway_resource.start.id}"
  http_method = "${aws_api_gateway_method_response.start_post.http_method}"
  status_code = "${aws_api_gateway_method_response.start_post.status_code}"

  response_templates = {
    "application/json" = ""
  }
}
