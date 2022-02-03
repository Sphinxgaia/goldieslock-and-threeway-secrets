
api_desc = "Big Bear"
api_path = "bigbear"
api_name = "bigbear"

injector_desc = "Middle Bear"
injector_path = "midbear"
injector_name = "midbear"

csi_desc = "Little Bear"
csi_path = "littlebear"
csi_name = "littlebear"

csi_secrets = {
  "soup" = {
    path = "soup"
    value = <<EOT
        {"gustative": "csi"}
    EOT
  }
  "chair" = {
    path = "chair"
    value = <<EOT
        {"etat": "goldieslocks"}
    EOT
  }
  "bed" = {
    path = "bed"
    value =  <<EOT
        {"qualite": "csi"}
    EOT
  }
}
injector_secrets = {
  "soup" = {
    path = "soup"
    value = <<EOT
        {"gustative": "injector"}
    EOT
  }
  "chair" = {
    path = "chair"
    value = <<EOT
        {"etat": "goldieslocks"}
    EOT
  }
  "bed" = {
    path = "bed"
    value = <<EOT
        {"qualite": "injector"}
    EOT
  }
}
api_secrets = {
  "soup" = {
    path = "soup"
    value = <<EOT
        {"gustative": "api"}
    EOT
  }
  "chair" = {
    path = "chair"
    value = <<EOT
        {"etat": "goldieslocks"}
    EOT
  }
  "bed" = {
    path = "bed"
    value = <<EOT
        {"qualite": "api"}
    EOT
  }
}


