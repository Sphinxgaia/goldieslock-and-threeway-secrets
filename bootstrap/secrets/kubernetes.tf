###################################################
# Kubernetes auth                                 #
###################################################

resource "vault_auth_backend" "kubernetes_csi" {
  type = "kubernetes"
  path = var.csi_path
}
resource "vault_auth_backend" "kubernetes_injector" {
  type = "kubernetes"
  path = var.injector_path
}
resource "vault_auth_backend" "kubernetes_api" {
  type = "kubernetes"
  path = var.api_path
}

data "kubernetes_service_account" "issuer" {
  metadata {
    name = "vault-master"
    namespace  = "vault-master"
  }
}

data "kubernetes_secret" "issuer" {
  metadata {
    name = data.kubernetes_service_account.issuer.default_secret_name
    namespace = "vault-master"
  }
}

resource "vault_kubernetes_auth_backend_config" "csi" {
  backend                = vault_auth_backend.kubernetes_csi.path
  kubernetes_host        = "https://kubernetes.default.svc"
#   kubernetes_ca_cert     = data.kubernetes_secret.issuer.data["ca.crt"]
  token_reviewer_jwt     = data.kubernetes_secret.issuer.data.token
  
}

resource "vault_kubernetes_auth_backend_config" "injector" {
  backend                = vault_auth_backend.kubernetes_injector.path
  kubernetes_host        = "https://kubernetes.default.svc"
#   kubernetes_ca_cert     = data.kubernetes_secret.issuer.data["ca.crt"]
  token_reviewer_jwt     = data.kubernetes_secret.issuer.data.token
  
}

resource "vault_kubernetes_auth_backend_config" "api" {
  backend                = vault_auth_backend.kubernetes_api.path
  kubernetes_host        = "https://kubernetes.default.svc"
#   kubernetes_ca_cert     = data.kubernetes_secret.issuer.data["ca.crt"]
  token_reviewer_jwt     = data.kubernetes_secret.issuer.data.token
  
}

