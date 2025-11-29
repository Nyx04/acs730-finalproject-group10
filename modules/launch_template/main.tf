data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}



resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-${var.environment}-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  
  iam_instance_profile {
    name = var.instance_profile_name 
  }
  
  vpc_security_group_ids = [var.instance_sg_id]
  
  # Use the script file with template variables
  user_data = base64encode(templatefile("${path.module}/../../scripts/upload_image.sh", {
    images_bucket = var.images_bucket
    page_title    = var.page_title
    team_names    = var.team_names
    environment   = var.environment
  }))
}