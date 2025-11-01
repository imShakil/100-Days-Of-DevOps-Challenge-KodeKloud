resource "aws_dynamodb_table" "kk_dynamodb" {
  name         = var.KKE_TABLE_NAME
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = var.KKE_TABLE_NAME
  }
}

resource "aws_iam_role" "kk_role" {
  name = var.KKE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = var.KKE_ROLE_NAME
  }
}

resource "aws_iam_policy" "kk_policy" {
  name        = var.KKE_POLICY_NAME
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DescribeImport",
          "dynamodb:DescribeContributorInsights",
          "dynamodb:ListTagsOfResource",
          "dynamodb:GetAbacStatus",
          "dynamodb:DescribeReservedCapacityOfferings",
          "dynamodb:PartiQLSelect",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeExport",
          "dynamodb:GetResourcePolicy",
          "dynamodb:DescribeKinesisStreamingDestination",
          "dynamodb:DescribeLimits",
          "dynamodb:BatchGetItem",
          "dynamodb:ConditionCheckItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:DescribeStream",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListStreams",
          "dynamodb:DescribeGlobalTableSettings",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeGlobalTable",
          "dynamodb:DescribeReservedCapacity",
          "dynamodb:DescribeBackup",
          "dynamodb:DescribeEndpoints",
          "dynamodb:GetRecords",
          "dynamodb:DescribeTableReplicaAutoScaling"
        ]
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.kk_dynamodb.arn,
          "${aws_dynamodb_table.kk_dynamodb.arn}/*"
        ]
      },
    ]
  })

  tags = {
    Name = var.KKE_POLICY_NAME
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.kk_role.name
  policy_arn = aws_iam_policy.kk_policy.arn
}
