resource "aws_api_gateway_rest_api" "factorio" {
  name        = "factorio"
  description = "This is an API to perform start and stop actions on factorio"
}

resource "aws_api_gateway_resource" "manage" {
  rest_api_id = "${aws_api_gateway_rest_api.factorio.id}"
  parent_id   = "${aws_api_gateway_rest_api.factorio.root_resource_id}"
  path_part   = "manage"
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = "${aws_api_gateway_rest_api.factorio.id}"
  resource_id   = "${aws_api_gateway_resource.manage.id}"
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = "${aws_api_gateway_rest_api.factorio.id}"
  resource_id             = "${aws_api_gateway_resource.manage.id}"
  http_method             = "${aws_api_gateway_method.post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.manage_factorio.arn}/invocations"
}

resource "aws_api_gateway_method_response" "post" {
  rest_api_id = "${aws_api_gateway_rest_api.factorio.id}"
  resource_id = "${aws_api_gateway_resource.manage.id}"
  http_method = "${aws_api_gateway_integration.lambda.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.factorio.id}"
  resource_id = "${aws_api_gateway_resource.manage.id}"
  http_method = "${aws_api_gateway_method_response.post.http_method}"
  status_code = "${aws_api_gateway_method_response.post.status_code}"

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "factorio" {
  depends_on = ["aws_api_gateway_method.post"]

  rest_api_id = "${aws_api_gateway_rest_api.factorio.id}"
  stage_name  = "factorio"

  stage_description = "Live api for factorio management"

}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name         = "rate-limiter"
  description  = "Limit calls to 2/s and 1k a day"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.factorio.id}"
    stage  = "${aws_api_gateway_deployment.factorio.stage_name}"
  }

  quota_settings {
    limit  = 1000
    offset = 0
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 1
    rate_limit  = 1
  }
}

resource "aws_api_gateway_api_key" "my_factorio_key" {
  name = "my-factorio-key"

  stage_key {
    rest_api_id = "${aws_api_gateway_rest_api.factorio.id}"
    stage_name  = "${aws_api_gateway_deployment.factorio.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "factorio" {
  key_id        = "${aws_api_gateway_api_key.my_factorio_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.usage_plan.id}"
}
