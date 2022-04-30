module "eks-cluster" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "17.1.0"
  cluster_name     = "${var.cluster_name}"
  cluster_version  = "1.20"
  write_kubeconfig = true

  subnets = module.vpc.private_subnets
  vpc_id  = module.vpc.vpc_id

 worker_groups_launch_template = local.worker_groups_launch_template

  map_users = concat(local.admin_user_map_users, local.developer_user_map_users)
}