###################################################
# Providers                                       #
###################################################

provider "helm" {
  # Configuration options
  kubernetes {
  }
}

provider "kubernetes" {
}


# provider "aws" {
#   region = "eu-west-3"
  
#   # export env
#   # access_key = "my-access-key"
#   # secret_key = "my-secret-key"
# }