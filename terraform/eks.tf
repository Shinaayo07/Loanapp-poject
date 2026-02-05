module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_name
  kubernetes_version = "1.34"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  control_plane_subnet_ids                 = module.vpc.private_subnets 
  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true


  eks_managed_node_groups = {
    loanapp-node-group = {
      name           = "loanapp-node-group"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]
      #ami_type      = "AL2_x86_64"
      disk_size      = 20

      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }

  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

}