

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Reference the existing LabInstanceProfile (don't create new one)
data "aws_iam_instance_profile" "lab_profile" {
  name = "LabInstanceProfile"
}

