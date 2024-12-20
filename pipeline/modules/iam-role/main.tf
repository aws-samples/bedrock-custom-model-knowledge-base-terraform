#This solution, non-production-ready template describes AWS Codepipeline based CICD Pipeline for terraform code deployment.
#© 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
#This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
#http://aws.amazon.com/agreement or other written agreement between Customer and either
#Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_iam_role" "codepipeline_role" {
  count              = var.create_new_role ? 1 : 0
  name               = var.codepipeline_iam_role_name
  tags               = var.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  path               = "/"
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeStarFullAccess" # Replace with required policy ARNs
  role       = aws_iam_role.codepipeline_role[0].name
}
resource "aws_iam_policy" "codepipeline_policy" {
  count       = var.create_new_role ? 1 : 0
  name        = "${var.project_name}-codepipeline-policy"
  description = "Policy to allow codepipeline to execute"
  tags        = var.tags
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [

        {
          "Effect" : "Allow",
          "Action" : [
            "s3:CreateBucket",
            "s3:List*",
            "s3:Get*",
            "s3:PutObject",
            "s3:PutBucketPublicAccessBlock",
            "s3:PutBucketVersioning",
            "s3:PutEncryptionConfiguration",
            "logs:CreateLogStream",
            "bedrock:*",
            "logs:*",
            "aoss:*",
            "lambda:AddPermission",
            "lambda:CreateFunction",
            "lambda:GetFunction",
            "lambda:GetFunctionCodeSigningConfig",
            "lambda:GetPolicy",
            "lambda:ListVersionsByFunction",
            "kms:Decrypt",
            "kms:DescribeKey",
            "kms:EnableKeyRotation",
            "kms:GenerateDataKey",
            "kms:GetKeyPolicy",
            "kms:GetKeyRotationStatus",
            "kms:ListResourceTags",
            "kms:PutKeyPolicy",
            "kms:TagResource",
            "iam:AttachRolePolicy",
            "iam:CreateRole",
            "iam:CreateServiceLinkedRole",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListAttachedRolePolicies",
            "iam:ListRolePolicies",
            "iam:PutRolePolicy",
            "iam:CreatePolicy",
            "iam:GetPolicy",
            "iam:GetPolicyVersion",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcs",
            "iam:ListPolicies",
            "kms:CreateKey",
            "sts:GetCallerIdentity",
            "codestar:*",
            "codestar-connections:*",
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild",
            "codebuild:BatchGetProjects",
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "cloudformation:CreateStack",
            "cloudformation:DeleteStack",
            "cloudformation:ListStacks",
            "cloudformation:List*",
            "cloudformation:GetResource*",
            "cloudformation:DescribeStacks",
            "cloudformation:UpdateStack",
            "cloudformation:CreateResource",
            "cloudformation:UpdateResource",
            "iam:PassRole"
          ],
          "Resource" : "*"
        }

      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_attach" {
  count      = var.create_new_role ? 1 : 0
  role       = aws_iam_role.codepipeline_role[0].name
  policy_arn = aws_iam_policy.codepipeline_policy[0].arn
}
