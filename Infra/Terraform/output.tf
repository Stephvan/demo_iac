output "eks_cluster_name" {
  value = aws_eks_cluster.eks-cluster.name
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks-cluster.arn
}

output "node_group_names" {
  value = [for node_group in aws_eks_node_group.node-ec2 : node_group.node_group_name]
}

output "eks_addon_names" {
  value = [for addon in aws_eks_addon.addons : addon.addon_name]
}

output "eks_addon_versions" {
  value = [for addon in aws_eks_addon.addons : addon.addon_version]
}

output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}

/* output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.default.url
} */

/* output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.default.arn
} */
