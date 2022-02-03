###################################################
# Variables                                       #
###################################################

variable "api_path" {
  type = string
  description= "Chemin de votre point de montage de secret pour la partie API"
  default = "api"
}

variable "api_desc" {
  type = string
  description= "Description de votre point de montage de secret pour la partie API"
  default = "api"
}

variable "api_name" {
  type = string
  description= "API name"
  default = "api"
}

variable "injector_path" {
  type = string
  description= "Chemin de votre point de montage de secret pour la partie Injector"
  default = "agent"
}

variable "injector_desc" {
  type = string
  description= "Description de votre point de montage de secret pour la partie Injector"
  default = "agent"
}

variable "injector_name" {
  type = string
  description= "Injector name"
  default = "agent"
}

variable "csi_path" {
  type = string
  description= "Chemin de votre point de montage de secret pour la partie CSI"
  default = "csi"
}

variable "csi_desc" {
  type = string
  description= "Description de votre point de montage de secret pour la partie CSI"
  default = "csi"
}

variable "csi_name" {
  type = string
  description= "CSI name"
  default = "csi"
}

variable "csi_secrets" {
  type = map(object({
    path = string
    value = string
  }))
  description = "Liste de secrets pour la partie CSI"
}
variable "injector_secrets" {
  type = map(object({
    path = string
    value = string
  }))
  description = "Liste de secrets pour la partie Injector"
}
variable "api_secrets" {
  type = map(object({
    path = string
    value = string
  }))
  description = "Liste de secrets pour la partie API"
}

variable "vault_addr" {
  type = string
  sensitive = true
  description = "Lien vers votre vault master"
  default = "http://localhost:8200"

}

variable "story_name" {
  type = string
  description= "Story name"
  default = ""
}