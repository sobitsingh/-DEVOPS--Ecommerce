variable "cluster_role_name" {
  default = "eks-role"
  description = "EKS cluster role name"
  type = string
}

variable "node_role_name" {
  default = "nodeRole"
  description = "EKS node role name"
  type = string
}

