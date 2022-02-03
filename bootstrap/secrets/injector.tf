###################################################
# Injector                                        #
###################################################

resource "vault_generic_secret" "secretinjector" {
  for_each = var.injector_secrets
  path = "${var.injector_path}/${each.value.path}"

  data_json = each.value.value
    depends_on = [
    vault_mount.kvinjector
    ]
}

# Création d'une policy pour l'accès au role Kubernetes
resource "vault_policy" "injector" {
  name = "injector-${var.story_name}"

  policy = <<EOT
path "${var.injector_path}/data/" {
  capabilities = ["read"]
}
path "${var.injector_path}/data/*" {
  capabilities = ["read"]
}
EOT
}

# Création du role Kubernetes pour l'utilisation en mode injector
resource "vault_kubernetes_auth_backend_role" "injector" {
  backend                          = vault_auth_backend.kubernetes_injector.path
  role_name                        = var.injector_name
  bound_service_account_names      = ["${var.story_name}"]
  bound_service_account_namespaces = ["${var.injector_name}-injector"]
  token_ttl                        = 3600
  token_policies                   = ["injector-${var.story_name}"]
  audience                         = null
}


resource "kubernetes_namespace" "injectorns" {
  metadata {
    name = "${var.injector_name}-injector"
  }
}

resource "kubernetes_service_account" "injector" {
  metadata {
    name = var.story_name
    namespace =  "${var.injector_name}-injector"
  }

  depends_on = [kubernetes_namespace.injectorns]
}