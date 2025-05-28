resource "aws_eks_cluster" "cluster" {
  name = "open-tele-eks"
  role_arn = module.iam.cluster_iam_role_arn

  vpc_config {
    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
    security_group_ids = [var.ec_frontend_sg_id]
  }
}

resource "aws_eks_node_group" "node-group" {
  cluster_name = aws_eks_cluster.cluster.name
  for_each = var.node_groups
  node_group_name = each.value.name
  node_role_arn = module.iam.node_iam_role_arn
  subnet_ids = each.value.subnet_ids
  
  instance_types = ["t2.medium"]
  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 1
  }
  depends_on = [
    module.iam.AmazonEC2ContainerRegistryReadOnly,
    module.iam.AmazonEKS_CNI_Policy,
    module.iam.AmazonEKSWorkerNodePolicy,
  ]
}

module "iam" {
  source = "../IAM"
}

