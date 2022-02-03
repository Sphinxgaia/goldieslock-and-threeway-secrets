###################################################
# API                                         #
###################################################

resource "vault_generic_secret" "secretapi" {
  for_each = var.api_secrets
  path = "${var.api_path}/${each.value.path}"

  data_json = each.value.value
    depends_on = [
    vault_mount.kvapi
    ]
}

# Création d'une policy pour l'accès au role Kubernetes
resource "vault_policy" "api" {
  name = "api-${var.story_name}"

  policy = <<EOT
path "${var.api_path}/data/" {
  capabilities = ["read"]
}
path "${var.api_path}/data/*" {
  capabilities = ["read"]
}
EOT
}

# Création du role Kubernetes pour l'utilisation en mode api
resource "vault_kubernetes_auth_backend_role" "api" {
  backend                          = vault_auth_backend.kubernetes_api.path
  role_name                        = var.api_name
  bound_service_account_names      = ["${var.story_name}"]
  bound_service_account_namespaces = ["${var.api_name}-api"]
  token_ttl                        = 3600
  token_policies                   = ["api-${var.story_name}"]
  audience                         = null
}


resource "kubernetes_namespace" "apins" {
  metadata {
    name = "${var.api_name}-api"
  }
}

resource "kubernetes_service_account" "api" {
  metadata {
    name = var.story_name
    namespace =  "${var.api_name}-api"
  }

  depends_on = [kubernetes_namespace.apins]
}