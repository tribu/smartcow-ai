locals {
  user_data = <<-EOT
  #!/bin/bash
  set -ex
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh ./get-docker.sh
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
  sudo chmod +x /usr/bin/docker-compose
  sudo -s docker-compose --version
  
  echo "version: '3.0'
  services:
    api:
      image: quay.io/tribuvan/smartcow:api-v1
      container_name: api
      ports:
      - \"8000:8000\"
      extra_hosts:
      - host.docker.internal:host-gateway
    web:
      image: quay.io/tribuvan/smartcow:node-v1
      container_name: node
      ports:
      - \"3000:3000\"
      extra_hosts:
      - host.docker.internal:host-gateway
    nginx:
      image: quay.io/tribuvan/smartcow:nginx-v1
      container_name: nginx
      ports:
      - \"8080:80\"
      extra_hosts:
      - host.docker.internal:host-gateway
  " > /opt/docker-compose.yml
  cd /opt
  sudo -s docker-compose up --build -d
  
  EOT
}


module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "${var.vpc_name}-asg"

  vpc_zone_identifier = module.vpc.public_subnets
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  image_id      = "ami-0f9ae27ecf629cbe3"
  key_name      = var.key_name
  instance_type = "t3.medium"
  user_data     = base64encode(local.user_data)

  security_groups = [aws_security_group.asg_ec2_sg.id]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 32
  }

  tags = {
    Name = "${var.vpc_name}-asg"
    Terraform = "true"
    Environment = "test"
  }
}
