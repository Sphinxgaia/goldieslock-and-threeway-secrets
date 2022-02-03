###################################################
# Providers                                       #
###################################################


provider "kubernetes" {
}

provider "vault" {
  address    = var.vault_addr
  add_address_to_env = true
}