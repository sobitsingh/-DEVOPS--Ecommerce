output "cluster_iam_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "node_iam_role_arn" {
  value = aws_iam_role.node.arn
}

output "eks_cluster-policy-attachment" {
  value = aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy.id
}

output "eks_worker-node-policy-attachment" {
  value = aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy.id
}

output "eks_cni-policy-attachment" {
  value = aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy.id
}

output "ecr_read-only-policy-attachment" {
  value = aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly.id
}

