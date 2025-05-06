data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}


# Trust Policy: Allow Bedrock to assume this role
data "aws_iam_policy_document" "bedrock_agent_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent/*",
        "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:knowledge-base/*"
      ]
    }
  }
}

# Permissions for Bedrock agent to use foundation models, invoke agents, etc.
data "aws_iam_policy_document" "bedrock_agent_permissions" {
  statement {
    actions = [
      "bedrock:InvokeModel"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}::foundation-model/anthropic.claude-3-5-sonnet-20241022-v2:0",
      "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}::foundation-model/amazon.titan-embed-text-v2:0"
    ]
  }

  statement {
    actions = [
      "bedrock:GetAgent",
      "bedrock:GetAgentAlias",
      "bedrock:InvokeAgent",
      "*"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent/*",
      "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent-alias/*",
      "*"
    ]
  }

  statement {
    actions = [
      "aoss:DescribeCollectionItems",
      "aoss:ReadDocument",
      "aoss:WriteDocument"
    ]
    resources = ["*"] # You can scope this to your collection ARN if needed
  }

  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::${var.existing_kb_bucket_name}/*"]
  }
}

# IAM Role for Bedrock agents
resource "aws_iam_role" "bedrock_agent_role" {
  name_prefix        = "AmazonBedrockExecutionRoleForAgents_"
  assume_role_policy = data.aws_iam_policy_document.bedrock_agent_trust.json
}

# Attach permissions to the role
resource "aws_iam_role_policy" "bedrock_agent_policy" {
  name   = "BedrockAgentPolicy"
  role   = aws_iam_role.bedrock_agent_role.id
  policy = data.aws_iam_policy_document.bedrock_agent_permissions.json
}