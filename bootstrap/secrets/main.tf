###################################################
# Main                                            #
###################################################

resource "vault_audit" "audit" {
  type = "file"

  options = {
    file_path = "stdout"
  }

}

# only for our sample
resource "vault_mount" "kvinjector" {
  path                      = var.injector_path
  type                      = "kv-v2"
  description               = var.injector_desc
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

# only for our sample
resource "vault_mount" "kvcsi" {
  path                      = var.csi_path
  type                      = "kv-v2"
  description               = var.csi_desc
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

# only for our sample
resource "vault_mount" "kvapi" {
  path                      = var.api_path
  type                      = "kv-v2"
  description               = var.api_desc
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}