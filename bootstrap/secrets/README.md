<!-- BEGIN_TF_DOCS -->
# Création de secret dans Vault

Configuration de votre environnement Vault

## Configuration de la partie Vault kubernetes

```bash

export VAULT_TOKEN=$ROOT_TOKEN
export KUBE_CONFIG_PATH=$KUBECONFIG
export KUBE_CTX=$TF_VAR_story_name

export TF_VAR_vault_addr="http://localhost:8200"
```

Lancer l'installation `don't do that in production`

```bash
terraform init
terraform apply -auto-approve

kubectl get ns | grep bear
kubectl get sa -A | grep bear
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.7.1 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.apins](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.csins](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.injectorns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.api](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_service_account.csi](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_service_account.injector](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [vault_audit.audit](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/audit) | resource |
| [vault_auth_backend.kubernetes_api](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend) | resource |
| [vault_auth_backend.kubernetes_csi](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend) | resource |
| [vault_auth_backend.kubernetes_injector](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend) | resource |
| [vault_generic_secret.secretapi](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/generic_secret) | resource |
| [vault_generic_secret.secretcsi](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/generic_secret) | resource |
| [vault_generic_secret.secretinjector](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/generic_secret) | resource |
| [vault_kubernetes_auth_backend_config.api](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_kubernetes_auth_backend_config.csi](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_kubernetes_auth_backend_config.injector](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_kubernetes_auth_backend_role.api](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_kubernetes_auth_backend_role.csi](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_kubernetes_auth_backend_role.injector](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_mount.kvapi](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/mount) | resource |
| [vault_mount.kvcsi](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/mount) | resource |
| [vault_mount.kvinjector](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/mount) | resource |
| [vault_policy.api](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/policy) | resource |
| [vault_policy.csi](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/policy) | resource |
| [vault_policy.injector](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/policy) | resource |
| [kubernetes_secret.issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |
| [kubernetes_service_account.issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_desc"></a> [api\_desc](#input\_api\_desc) | Description de votre point de montage de secret pour la partie API | `string` | `"api"` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | API name | `string` | `"api"` | no |
| <a name="input_api_path"></a> [api\_path](#input\_api\_path) | Chemin de votre point de montage de secret pour la partie API | `string` | `"api"` | no |
| <a name="input_api_secrets"></a> [api\_secrets](#input\_api\_secrets) | Liste de secrets pour la partie API | <pre>map(object({<br>    path = string<br>    value = string<br>  }))</pre> | n/a | yes |
| <a name="input_csi_desc"></a> [csi\_desc](#input\_csi\_desc) | Description de votre point de montage de secret pour la partie CSI | `string` | `"csi"` | no |
| <a name="input_csi_name"></a> [csi\_name](#input\_csi\_name) | CSI name | `string` | `"csi"` | no |
| <a name="input_csi_path"></a> [csi\_path](#input\_csi\_path) | Chemin de votre point de montage de secret pour la partie CSI | `string` | `"csi"` | no |
| <a name="input_csi_secrets"></a> [csi\_secrets](#input\_csi\_secrets) | Liste de secrets pour la partie CSI | <pre>map(object({<br>    path = string<br>    value = string<br>  }))</pre> | n/a | yes |
| <a name="input_injector_desc"></a> [injector\_desc](#input\_injector\_desc) | Description de votre point de montage de secret pour la partie Injector | `string` | `"agent"` | no |
| <a name="input_injector_name"></a> [injector\_name](#input\_injector\_name) | Injector name | `string` | `"agent"` | no |
| <a name="input_injector_path"></a> [injector\_path](#input\_injector\_path) | Chemin de votre point de montage de secret pour la partie Injector | `string` | `"agent"` | no |
| <a name="input_injector_secrets"></a> [injector\_secrets](#input\_injector\_secrets) | Liste de secrets pour la partie Injector | <pre>map(object({<br>    path = string<br>    value = string<br>  }))</pre> | n/a | yes |
| <a name="input_story_name"></a> [story\_name](#input\_story\_name) | Story name | `string` | `""` | no |
| <a name="input_vault_addr"></a> [vault\_addr](#input\_vault\_addr) | Lien vers votre vault master | `string` | `"http://localhost:8200"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->