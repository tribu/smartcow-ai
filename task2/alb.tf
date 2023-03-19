#////////////////////////////////
#   LoadBalancer
#////////////////////////////////
resource "aws_lb" "this" {
  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id, aws_security_group.asg_ec2_sg.id]
  subnets         = module.vpc.public_subnets

  tags = {
    Name = "${var.vpc_name}-alb"
    Terraform = "true"
    Environment = "test"
  }

}

resource "aws_lb_target_group" "this" {
  name     = "${var.vpc_name}-alb"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  tags = {
    Name = "${var.vpc_name}-alb"
    Terraform = "true"
    Environment = "test"
  }
}

#////////////////////////////////
#   Auto Scaling Attachment
#////////////////////////////////
# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = module.asg.autoscaling_group_id
  alb_target_group_arn   = aws_lb_target_group.this.arn
}


#////////////////////////////////
#   AWS LoadBalancing Listener
#////////////////////////////////
# Create a new ALB Target Group attachment

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}