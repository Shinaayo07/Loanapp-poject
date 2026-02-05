provider "aws" {
  region = var.region
}

locals {
  cluster_name = var.clusterName
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}
