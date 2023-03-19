## Task 1 - Dockerize the Applications
1. Create a docker repo.
2. from the root directory run the below command to build api,node and nginx docker container

docker build -t quay.io/tribuvan/smartcow:api-v1 -f task1/api/Dockerfile .
docker push quay.io/tribuvan/smartcow:api-v1


docker build -t quay.io/tribuvan/smartcow:node-v1 -f task1/node/Dockerfile .
docker push quay.io/tribuvan/smartcow:node-v1

docker build -t quay.io/tribuvan/smartcow:nginx-v1 -f task1/nginx/Dockerfile .
docker push quay.io/tribuvan/smartcow:nginx-v1

3. docker-compose up -d --build
4. to verify run command
   docker ps
   curl -svo /dev/null http://localhost:8000/stats
   curl -svo /dev/null http://localhost:3000
   curl -svo /dev/null http://localhost:8080


## Task 2 - Deploy on Cloud
1. cd to task2 folder . This folder has the terraform file for creating
   a) vpc
   b) subnets ( 2 pvt and 2 pub subnets)
   c) Security groups( ASG security group and ALB ecurity group )
   c) ASG in private subnets with userdata file configured to bring the docker-compose from taks1
   d) ALB with ASG from step (1c) as the target group

   Please see video task2 attached to email for demo.

 2. terraform plan -out plan.out
    terraform apply plan.out

 *************sample terraform plan *************************
 ************************************************************

 terraform plan -out plan.out
module.asg.data.aws_partition.current: Reading...
module.asg.data.aws_default_tags.current: Reading...
module.asg.data.aws_partition.current: Read complete after 0s [id=aws]
module.asg.data.aws_default_tags.current: Read complete after 0s [id=aws]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_autoscaling_attachment.this will be created
  + resource "aws_autoscaling_attachment" "this" {
      + alb_target_group_arn   = (known after apply)
      + autoscaling_group_name = (known after apply)
      + id                     = (known after apply)
    }

  # aws_lb.this will be created
  + resource "aws_lb" "this" {
      + arn                                         = (known after apply)
      + arn_suffix                                  = (known after apply)
      + desync_mitigation_mode                      = "defensive"
      + dns_name                                    = (known after apply)
      + drop_invalid_header_fields                  = false
      + enable_deletion_protection                  = false
      + enable_http2                                = true
      + enable_tls_version_and_cipher_suite_headers = false
      + enable_waf_fail_open                        = false
      + enable_xff_client_port                      = false
      + id                                          = (known after apply)
      + idle_timeout                                = 60
      + internal                                    = false
      + ip_address_type                             = (known after apply)
      + load_balancer_type                          = "application"
      + name                                        = "test-alb"
      + preserve_host_header                        = false
      + security_groups                             = (known after apply)
      + subnets                                     = (known after apply)
      + tags                                        = {
          + "Environment" = "test"
          + "Name"        = "test-alb"
          + "Terraform"   = "true"
        }
      + tags_all                                    = {
          + "Environment" = "test"
          + "Name"        = "test-alb"
          + "Terraform"   = "true"
        }
      + vpc_id                                      = (known after apply)
      + xff_header_processing_mode                  = "append"
      + zone_id                                     = (known after apply)

      + subnet_mapping {
          + allocation_id        = (known after apply)
          + ipv6_address         = (known after apply)
          + outpost_id           = (known after apply)
          + private_ipv4_address = (known after apply)
          + subnet_id            = (known after apply)
        }
    }

  # aws_lb_listener.this will be created
  + resource "aws_lb_listener" "this" {
      + arn               = (known after apply)
      + id                = (known after apply)
      + load_balancer_arn = (known after apply)
      + port              = 80
      + protocol          = "HTTP"
      + ssl_policy        = (known after apply)
      + tags_all          = (known after apply)

      + default_action {
          + order            = (known after apply)
          + target_group_arn = (known after apply)
          + type             = "forward"
        }
    }

  # aws_lb_target_group.this will be created
  + resource "aws_lb_target_group" "this" {
      + arn                                = (known after apply)
      + arn_suffix                         = (known after apply)
      + connection_termination             = false
      + deregistration_delay               = "300"
      + id                                 = (known after apply)
      + ip_address_type                    = (known after apply)
      + lambda_multi_value_headers_enabled = false
      + load_balancing_algorithm_type      = (known after apply)
      + load_balancing_cross_zone_enabled  = (known after apply)
      + name                               = "test-alb"
      + port                               = 8080
      + preserve_client_ip                 = (known after apply)
      + protocol                           = "HTTP"
      + protocol_version                   = (known after apply)
      + proxy_protocol_v2                  = false
      + slow_start                         = 0
      + tags                               = {
          + "Environment" = "test"
          + "Name"        = "test-alb"
          + "Terraform"   = "true"
        }
      + tags_all                           = {
          + "Environment" = "test"
          + "Name"        = "test-alb"
          + "Terraform"   = "true"
        }
      + target_type                        = "instance"
      + vpc_id                             = (known after apply)

      + health_check {
          + enabled             = (known after apply)
          + healthy_threshold   = (known after apply)
          + interval            = (known after apply)
          + matcher             = (known after apply)
          + path                = (known after apply)
          + port                = (known after apply)
          + protocol            = (known after apply)
          + timeout             = (known after apply)
          + unhealthy_threshold = (known after apply)
        }

      + stickiness {
          + cookie_duration = (known after apply)
          + cookie_name     = (known after apply)
          + enabled         = (known after apply)
          + type            = (known after apply)
        }

      + target_failover {
          + on_deregistration = (known after apply)
          + on_unhealthy      = (known after apply)
        }
    }

  # aws_security_group.alb_sg will be created
  + resource "aws_security_group" "alb_sg" {
      + arn                    = (known after apply)
      + description            = "Allow 8080 inbound traffic for nginx"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = [
                  + "::/0",
                ]
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "http-80"
              + from_port        = 8000
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8000
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "http-80"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
        ]
      + name                   = "test-alb-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Environment" = "test"
          + "Name"        = "test-alb-sg"
          + "Terraform"   = "true"
        }
      + tags_all               = {
          + "Environment" = "test"
          + "Name"        = "test-alb-sg"
          + "Terraform"   = "true"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.asg_ec2_sg will be created
  + resource "aws_security_group" "asg_ec2_sg" {
      + arn                    = (known after apply)
      + description            = "Allow 8080 inbound traffic for nginx"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = [
                  + "::/0",
                ]
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "10.0.0.0/16",
                ]
              + description      = "http-8080"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
          + {
              + cidr_blocks      = [
                  + "49.36.233.220/32",
                ]
              + description      = "ssh tribu"
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
          + {
              + cidr_blocks      = []
              + description      = "http-8080"
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = (known after apply)
              + self             = false
              + to_port          = 8080
            },
        ]
      + name                   = "test-asg-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Environment" = "test"
          + "Name"        = "test-asg-sg"
          + "Terraform"   = "true"
        }
      + tags_all               = {
          + "Environment" = "test"
          + "Name"        = "test-asg-sg"
          + "Terraform"   = "true"
        }
      + vpc_id                 = (known after apply)
    }

  # module.asg.aws_autoscaling_group.this[0] will be created
  + resource "aws_autoscaling_group" "this" {
      + arn                       = (known after apply)
      + availability_zones        = (known after apply)
      + default_cooldown          = (known after apply)
      + desired_capacity          = 1
      + force_delete              = false
      + force_delete_warm_pool    = false
      + health_check_grace_period = 300
      + health_check_type         = (known after apply)
      + id                        = (known after apply)
      + max_size                  = 1
      + metrics_granularity       = "1Minute"
      + min_size                  = 0
      + name                      = (known after apply)
      + name_prefix               = "test-asg-"
      + protect_from_scale_in     = false
      + service_linked_role_arn   = (known after apply)
      + termination_policies      = []
      + vpc_zone_identifier       = (known after apply)
      + wait_for_capacity_timeout = "10m"

      + launch_template {
          + id      = (known after apply)
          + name    = (known after apply)
          + version = (known after apply)
        }

      + tag {
          + key                 = "Environment"
          + propagate_at_launch = true
          + value               = "test"
        }
      + tag {
          + key                 = "Name"
          + propagate_at_launch = true
          + value               = "test-asg"
        }
      + tag {
          + key                 = "Terraform"
          + propagate_at_launch = true
          + value               = "true"
        }

      + timeouts {}
    }

  # module.asg.aws_launch_template.this[0] will be created
  + resource "aws_launch_template" "this" {
      + arn                    = (known after apply)
      + default_version        = (known after apply)
      + id                     = (known after apply)
      + image_id               = "ami-0f9ae27ecf629cbe3"
      + instance_type          = "t3.medium"
      + key_name               = "tribu"
      + latest_version         = (known after apply)
      + name                   = (known after apply)
      + name_prefix            = "test-asg-"
      + tags                   = {
          + "Environment" = "test"
          + "Name"        = "test-asg"
          + "Terraform"   = "true"
        }
      + tags_all               = {
          + "Environment" = "test"
          + "Name"        = "test-asg"
          + "Terraform"   = "true"
        }
      + user_data              = "IyEvYmluL2Jhc2gKc2V0IC1leApjdXJsIC1mc1NMIGh0dHBzOi8vZ2V0LmRvY2tlci5jb20gLW8gZ2V0LWRvY2tlci5zaApzdWRvIHNoIC4vZ2V0LWRvY2tlci5zaApzdWRvIGN1cmwgLUwgImh0dHBzOi8vZ2l0aHViLmNvbS9kb2NrZXIvY29tcG9zZS9yZWxlYXNlcy9kb3dubG9hZC8xLjI5LjIvZG9ja2VyLWNvbXBvc2UtJCh1bmFtZSAtcyktJCh1bmFtZSAtbSkiIC1vIC91c3IvYmluL2RvY2tlci1jb21wb3NlCnN1ZG8gY2htb2QgK3ggL3Vzci9iaW4vZG9ja2VyLWNvbXBvc2UKc3VkbyAtcyBkb2NrZXItY29tcG9zZSAtLXZlcnNpb24KICAKZWNobyAidmVyc2lvbjogJzMuMCcKc2VydmljZXM6CiAgYXBpOgogICAgaW1hZ2U6IHF1YXkuaW8vdHJpYnV2YW4vc21hcnRjb3c6YXBpLXYxCiAgICBjb250YWluZXJfbmFtZTogYXBpCiAgICBwb3J0czoKICAgIC0gXCI4MDAwOjgwMDBcIgogICAgZXh0cmFfaG9zdHM6CiAgICAtIGhvc3QuZG9ja2VyLmludGVybmFsOmhvc3QtZ2F0ZXdheQogIHdlYjoKICAgIGltYWdlOiBxdWF5LmlvL3RyaWJ1dmFuL3NtYXJ0Y293Om5vZGUtdjEKICAgIGNvbnRhaW5lcl9uYW1lOiBub2RlCiAgICBwb3J0czoKICAgIC0gXCIzMDAwOjMwMDBcIgogICAgZXh0cmFfaG9zdHM6CiAgICAtIGhvc3QuZG9ja2VyLmludGVybmFsOmhvc3QtZ2F0ZXdheQogIG5naW54OgogICAgaW1hZ2U6IHF1YXkuaW8vdHJpYnV2YW4vc21hcnRjb3c6bmdpbngtdjEKICAgIGNvbnRhaW5lcl9uYW1lOiBuZ2lueAogICAgcG9ydHM6CiAgICAtIFwiODA4MDo4MFwiCiAgICBleHRyYV9ob3N0czoKICAgIC0gaG9zdC5kb2NrZXIuaW50ZXJuYWw6aG9zdC1nYXRld2F5CiIgPiAvb3B0L2RvY2tlci1jb21wb3NlLnltbApjZCAvb3B0CnN1ZG8gLXMgZG9ja2VyLWNvbXBvc2UgdXAgLS1idWlsZCAtZAogIAo="
      + vpc_security_group_ids = (known after apply)

      + metadata_options {
          + http_endpoint               = "enabled"
          + http_protocol_ipv6          = "disabled"
          + http_put_response_hop_limit = 32
          + http_tokens                 = "optional"
          + instance_metadata_tags      = "disabled"
        }

      + monitoring {
          + enabled = true
        }
    }

  # module.vpc.aws_eip.nat[0] will be created
  + resource "aws_eip" "nat" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Environment" = "test"
          + "Name"        = "test-eu-west-1a"
          + "Terraform"   = "true"
        }
      + tags_all             = {
          + "Environment" = "test"
          + "Name"        = "test-eu-west-1a"
          + "Terraform"   = "true"
        }
      + vpc                  = true
    }

  # module.vpc.aws_eip.nat[1] will be created
  + resource "aws_eip" "nat" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Environment" = "test"
          + "Name"        = "test-eu-west-1b"
          + "Terraform"   = "true"
        }
      + tags_all             = {
          + "Environment" = "test"
          + "Name"        = "test-eu-west-1b"
          + "Terraform"   = "true"
        }
      + vpc                  = true
    }

  # module.vpc.aws_internet_gateway.this[0] will be created
  + resource "aws_internet_gateway" "this" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Environment" = "test"
          + "Name"        = "test"
          + "Terraform"   = "true"
        }
      + tags_all = {
          + "Environment" = "test"
          + "Name"        = "test"
          + "Terraform"   = "true"
        }
      + vpc_id   = (known after apply)
    }

  # module.vpc.aws_nat_gateway.this[0] will be created
  + resource "aws_nat_gateway" "this" {
      + allocation_id        = (known after apply)
      + connectivity_type    = "public"
      + id                   = (known after apply)
      + network_interface_id = (known after apply)
      + private_ip           = (known after apply)
      + public_ip            = (known after apply)
      + subnet_id            = (known after apply)
      + tags                 = {
          + "Environment" = "test"
          + "Name"        = "test-eu-west-1a"
          + "Terraform"   = "true"
        }
      + tags_all             = {
          + "Environment" = "test"
          + "Name"        = "test-eu-west-1a"
          + "Terraform"   = "true"
        }
    }

  # module.vpc.aws_nat_gateway.this[1] will be created
  + resource "aws_nat_gateway" "this" {
      + allocation_id        = (known after apply)
      + connectivity_type    = "public"
      + id                   = (known after apply)
      + network_interface_id = (known after apply)
      + private_ip           = (known after apply)
      + public_ip            = (known after apply)
      + subnet_id            = (known after apply)
      + tags                 = {
          + "Environment" = "test"
          + "Name"        = "test-eu-west-1b"
          + "Terraform"   = "true"
        }
      + tags_all             = {
          + "Environment" = "test"
          + "Name"        = "test-eu-west-1b"
          + "Terraform"   = "true"
        }
    }

  # module.vpc.aws_route.private_nat_gateway[0] will be created
  + resource "aws_route" "private_nat_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + nat_gateway_id         = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc.aws_route.private_nat_gateway[1] will be created
  + resource "aws_route" "private_nat_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + nat_gateway_id         = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc.aws_route.public_internet_gateway[0] will be created
  + resource "aws_route" "public_internet_gateway" {
      + destination_cidr_block = "0.0.0.0/0"
      + gateway_id             = (known after apply)
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)

      + timeouts {
          + create = "5m"
        }
    }

  # module.vpc.aws_route_table.private[0] will be created
  + resource "aws_route_table" "private" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "Environment" = "test"
          + "Name"        = "test-private-eu-west-1a"
          + "Terraform"   = "true"
        }
      + tags_all         = {
          + "Environment" = "test"
          + "Name"        = "test-private-eu-west-1a"
          + "Terraform"   = "true"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table.private[1] will be created
  + resource "aws_route_table" "private" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "Environment" = "test"
          + "Name"        = "test-private-eu-west-1b"
          + "Terraform"   = "true"
        }
      + tags_all         = {
          + "Environment" = "test"
          + "Name"        = "test-private-eu-west-1b"
          + "Terraform"   = "true"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table.public[0] will be created
  + resource "aws_route_table" "public" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags             = {
          + "Environment" = "test"
          + "Name"        = "test-public"
          + "Terraform"   = "true"
        }
      + tags_all         = {
          + "Environment" = "test"
          + "Name"        = "test-public"
          + "Terraform"   = "true"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc.aws_route_table_association.private[0] will be created
  + resource "aws_route_table_association" "private" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.private[1] will be created
  + resource "aws_route_table_association" "private" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public[0] will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_route_table_association.public[1] will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc.aws_subnet.private[0] will be created
  + resource "aws_subnet" "private" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Environment" = "test"
          + "Name"        = "test-private-eu-west-1a"
          + "Terraform"   = "true"
        }
      + tags_all                                       = {
          + "Environment" = "test"
          + "Name"        = "test-private-eu-west-1a"
          + "Terraform"   = "true"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.private[1] will be created
  + resource "aws_subnet" "private" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Environment" = "test"
          + "Name"        = "test-private-eu-west-1b"
          + "Terraform"   = "true"
        }
      + tags_all                                       = {
          + "Environment" = "test"
          + "Name"        = "test-private-eu-west-1b"
          + "Terraform"   = "true"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.public[0] will be created
  + resource "aws_subnet" "public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.101.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Environment" = "test"
          + "Name"        = "test-public-eu-west-1a"
          + "Terraform"   = "true"
        }
      + tags_all                                       = {
          + "Environment" = "test"
          + "Name"        = "test-public-eu-west-1a"
          + "Terraform"   = "true"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_subnet.public[1] will be created
  + resource "aws_subnet" "public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.102.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Environment" = "test"
          + "Name"        = "test-public-eu-west-1b"
          + "Terraform"   = "true"
        }
      + tags_all                                       = {
          + "Environment" = "test"
          + "Name"        = "test-public-eu-west-1b"
          + "Terraform"   = "true"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc.aws_vpc.this[0] will be created
  + resource "aws_vpc" "this" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = false
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Environment" = "test"
          + "Name"        = "test"
          + "Terraform"   = "true"
        }
      + tags_all                             = {
          + "Environment" = "test"
          + "Name"        = "test"
          + "Terraform"   = "true"
        }
    }

  # module.vpc.aws_vpn_gateway.this[0] will be created
  + resource "aws_vpn_gateway" "this" {
      + amazon_side_asn = "64512"
      + arn             = (known after apply)
      + id              = (known after apply)
      + tags            = {
          + "Environment" = "test"
          + "Name"        = "test"
          + "Terraform"   = "true"
        }
      + tags_all        = {
          + "Environment" = "test"
          + "Name"        = "test"
          + "Terraform"   = "true"
        }
      + vpc_id          = (known after apply)
    }

Plan: 29 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: plan.out

To perform exactly these actions, run the following command to apply:
    terraform apply "plan.out"

 ************************************************************
 ************************************************************







### Task 3 - Get it to work with Kubernetes

1. Instead of using minikube; I used an existing EKS cluster on aws.
2. There are 3 deployment file api.yaml,node.yaml and nginx.yaml
3. And there is on ingress.yaml file for creating ALB with nginx service as target group


please see video task3 for the demo.
