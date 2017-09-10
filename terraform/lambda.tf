resource "aws_iam_role" "iam_for_lambda" {
  name = "factorio_iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy" "allow_asg_access" {
  name        = "factorio-allow-asg-access"
  path        = "/"
  description = "Allow lambda to change the autoscaling:SetDesiredCapacity setting on factorio asg"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1504922516544",
      "Action": [
        "autoscaling:SetDesiredCapacity"
      ],
      "Effect": "Allow",
      "Resource": "${aws_autoscaling_group.factorio.arn}"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "allow_asg_access" {
    role       = "${aws_iam_role.iam_for_lambda.name}"
    policy_arn = "${aws_iam_policy.allow_asg_access.arn}"
}

resource "aws_lambda_function" "start_factorio" {
  filename         = "start_factorio.zip"
  function_name    = "start_factorio"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "start_factorio.handler"
  source_code_hash = "${base64sha256(file("start_factorio.zip"))}"
  runtime          = "nodejs6.10"

  environment {
    variables = {
      ASG_NAME = "factorio"
      REGION = "${var.aws_region}"
    }
  }
}

# Allow api gateway
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.start_factorio.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.factorio.id}/*/${aws_api_gateway_method.start_post.http_method}${aws_api_gateway_resource.start.path}"
}

