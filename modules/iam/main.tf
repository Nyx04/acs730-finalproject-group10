data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project}-${var.environment}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.common_tags
}

resource "aws_iam_policy" "s3_read_policy" {
  name   = "${var.project}-${var.environment}-S3ReadPolicy"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.images_bucket}",
          "arn:aws:s3:::${var.images_bucket}/*"
        ]
      }
    ]
  })
  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project}-${var.environment}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}
