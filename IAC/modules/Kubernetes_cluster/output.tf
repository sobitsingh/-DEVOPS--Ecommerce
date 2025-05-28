output "eks-cluster" {
  value = {
    name = aws_eks_cluster.cluster.name
    cluster_endpoint = aws_eks_cluster.cluster.endpoint
    }
  }

output "eks-node-group" {
  value = {
    node_group_name = [for node_group in aws_eks_node_group.node-group : node_group.node_group_name]
    node_group_arn = [for node_group in aws_eks_node_group.node-group : node_group.arn]
  }
} 