###################################################
# Requirements                                    #
###################################################

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.6.1"
    }
  }
}
