output "vpc_id" {
  value = aws_vpc.open_tele_vpc.id
}

output "public-subnet-ids" {
  value = aws_subnet.public[*].id
}

output "private-subnet-ids" {
  value = aws_subnet.private[*].id
}

output "ec-frontend-sg-id" {
  value = aws_security_group.ec2-frontend-sg.id
}