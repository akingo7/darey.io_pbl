data "aws_availability_zones" "available_azs" {
state = "available"
}
data "aws_caller_identity" "current" {}
data "aws_eks_cluster" "cluster" {
name = module.eks-cluster.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
name = module.eks-cluster.cluster_id
}
