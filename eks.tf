module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.21.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnet_ids      = module.vpc.private_subnets

  tags = {
    Name = "Demo-EKS-Cluster"
  }

  vpc_id = module.vpc.vpc_id
  eks_managed_node_groups = {
    worker_group_one = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t2.micro"]
      remote_access = {
        source_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      }
    }
    worker_group_two = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t2.micro"]
      remote_access = {
        source_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      }
    }
  }

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
