###################################################
# Variables                                       #
###################################################


variable "namespace_prefix" {
  type = string
  description = "Prefix de l'ensemble de vos namespadces Vault"
  default = "vault"
}

variable "csi" {
  type = bool
  description = "Installation du CSI Driver"
  default = false
}

variable "injector" {
  type = bool
  description = "installation de l'injecteur"
  default = false
}
