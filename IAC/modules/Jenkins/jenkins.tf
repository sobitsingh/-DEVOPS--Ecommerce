resource "aws_iam_instance_profile" "jenkins_Insances_profile"{
    name = "jenkins"
    role = module.jenkins_iam.jenkins_role
}
resource "aws_instance" "jenkins"{
    instance_type = "t2.medium"
    ami = "ami-084568db4383264d4"
    subnet_id                   = var.subnet_id  
    associate_public_ip_address = true
    vpc_security_group_ids = [ var.sg_id]
    iam_instance_profile = aws_iam_instance_profile.jenkins_Insances_profile.name
    tags = {
    Name = "jenkins"
  }
}
module "jenkins_iam" {
  source = "../IAM-Jenkins"
}
