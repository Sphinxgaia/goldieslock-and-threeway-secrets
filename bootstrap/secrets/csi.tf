###################################################
# CSI                                             #
###################################################

resource "vault_generic_secret" "secretcsi" {
  for_each = var.csi_secrets
  path = "${var.csi_path}/${each.value.path}"

  data_json = each.value.value
    depends_on = [
    vault_mount.kvcsi
    ]
}

# Création d'une policy pour l'accès au role Kubernetes
resource "vault_policy" "csi" {
  name = "csi-${var.story_name}"

  policy = <<EOT
path "${var.csi_path}/data/" {
  capabilities = ["read"]
}
path "${var.csi_path}/data/*" {
  capabilities = ["read"]
}
EOT
}

# Création du role Kubernetes pour l'utilisation en mode CSI
resource "vault_kubernetes_auth_backend_role" "csi" {
  backend                          = vault_auth_backend.kubernetes_csi.path
  role_name                        = var.csi_name
  bound_service_account_names      = ["${var.story_name}"]
  bound_service_account_namespaces = ["${var.csi_name}-csi"]
  token_ttl                        = 3600
  token_policies                   = ["csi-${var.story_name}"]
  audience                         = null
}

resource "kubernetes_namespace" "csins" {
  metadata {
    name = "${var.csi_name}-csi"
  }
}

resource "kubernetes_service_account" "csi" {
  metadata {
    name = var.story_name
    namespace =  "${var.csi_name}-csi"
  }

  depends_on = [kubernetes_namespace.csins]
}