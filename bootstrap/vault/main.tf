###################################################
# Main                                            #
###################################################

locals {
  config_hcl = file("files/master-config.hcl")
  # config_hcl = var.aws ? join ("", [file("files/master-config.hcl"), var.aws_kms_config]) : file("files/master-config.hcl")
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = "${var.namespace_prefix}-master"
  }
}

resource "helm_release" "vault" {

  name       = "${var.namespace_prefix}-master"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.19.0"

  namespace = "${var.namespace_prefix}-master"

  set {
    name  = "injector.enabled"
    value = var.injector
  }

  set {
    name  = "csi.enabled"
    value = var.csi
  }

  set {
    name  = "csi.debug"
    value = var.csi
  }
  

  set {
    name  = "server.standalone.config"
    value  = local.config_hcl
  }

  set {
    name  = "server.dataStorage.enabled"
    value  = true
  }

  set {
    name  = "server.dataStorage.size"
    value  = "1Gi"
  }

  depends_on = [
    kubernetes_namespace.vault
  ]
}
 