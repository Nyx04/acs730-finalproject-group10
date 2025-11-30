#!/bin/bash
# Update system and install Apache + AWS CLI
yum update -y
yum install -y httpd awscli

# CHANGE APACHE TO LISTEN ON PORT 8080
sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf

systemctl enable httpd
systemctl start httpd

# Download site image from S3 (bucket must not be public)
aws s3 cp s3://${images_bucket}/site-image.jpg /var/www/html/site-image.jpg || true

# Create index.html
cat > /var/www/html/index.html <<EOT
<html>
<head><title>${page_title}</title></head>
<body>
<h1>${page_title}</h1>
<p>Team: ${team_names}</p>
<img src="site-image.jpg" alt="S3 Image" width="400"/>
<p>Environment: ${environment}</p>
</body>
</html>
EOT