resource "aws_iam_instance_profile" "jenkins_Insances_profile"{
    name = "jenkins"
    role = module.jenkins_iam.jenkins_role
}

resource "aws_key_pair" "jenkins" {
  key_name = "jenkins"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDANEQCL9Bb+lMP2+l/0IjG6oHxJf7dVIoKWzkeWrUzi+aA9c7qIEStvvQ41s22GCCwQgC9+cLRashjhs/w8N3HACWjg/cEgLPmH9zt5m7ZctKmrUOnMmpJ276eMP46J36ye7CyamIKLfYB8+irvcUSIDoktccmMLetjgCMIW/LEEgTWS73IwAOysHTNSSryck3DdmVyRUK7vushv1FVMTxnTcVjazN//uAHPwau6VS/THSXtjcsSxM6cvs8FBBRuo7jZtlu8gFLaxbFoWRnIisIslCM8HwiqXtVYWrIV1QqLvvbyK5VLh5XlHTzh5jac4PbG+jLsQXkZVey0JuKon3"
}

resource "aws_instance" "jenkins"{
    instance_type = "t2.medium"
    ami = "ami-084568db4383264d4"
    subnet_id                   = var.subnet_id  
    associate_public_ip_address = true
    vpc_security_group_ids = [ var.sg_id]
    key_name = aws_key_pair.jenkins.key_name
    iam_instance_profile = aws_iam_instance_profile.jenkins_Insances_profile.name
    tags = {
    Name = "jenkins"
  }
}
module "jenkins_iam" {
  source = "../IAM-Jenkins"
}
