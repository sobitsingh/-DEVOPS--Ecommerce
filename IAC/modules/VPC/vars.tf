variable "ingress" {
  description = "List of ingress rules for the security group"
  type = list(number)
  default = [ 80,443,22,8080,20001,9090 ]
}

variable "egress" {
  description = "List of egress rules for the security group"
  type = list(number)
  default = [ 80,443,22,8080,20001,9090 ]
}

variable "ec2-frontend-sg" {
  description = "Name of the security group"
  type = string
  default = "ec2-frontend-sg"
}

variable "public-subnet-cidr_block" {
  description = "CIDR of public subnet"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private-subnet-cidr_block" {
  default = ["10.0.3.0/24","10.0.4.0/24"]
  type = list(string)
  description = "value of private subnet cidr block"
}

variable "availability_zone_public" {
  default = ["us-east-1a","us-east-1b"]
  type = list(string)
  description = "value of availability zone in public subnet"
}

variable "availability_zone_private" {
  default = ["us-east-1c","us-east-1d"]
  type = list(string)
  description = "value of availability zone in private subnet"
  
}