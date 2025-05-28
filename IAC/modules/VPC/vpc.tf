resource "aws_vpc" "open_tele_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "ec2-frontend-sg" {
  name = var.ec2-frontend-sg
  vpc_id = aws_vpc.open_tele_vpc.id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port = egress.value
      to_port = egress.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
    tags = {
      Name = "ec2-frontend"
    }
}
