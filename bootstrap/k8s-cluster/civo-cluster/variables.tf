variable "civo_token" {
    sensitive = true
    type = string
    description = "Civo API Token"
}

variable "story_name" {
  type = string
  default = "my_kube_cluster"
}