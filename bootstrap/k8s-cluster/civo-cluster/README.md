<!-- BEGIN_TF_DOCS -->
# Création d'un cluster Kubernetes sur CIVO

Configuration de votre cluster

## Configuration de la partie kubernetes

Choisissez le nom de votre histoire

```bash
export CIVO_TOKEN=my_token

cd $WORK_HOME/bootstrap/k8s-cluster/civo-cluster

cat <<EOF > creds.auto.tfvars
civo_token = "$CIVO_TOKEN"
EOF

export TF_VAR_story_name=goldieslocks
```

Lancer l'installation

```bash
terraform init
terraform apply -auto-approve # don't do that in production
```

## Vérifier que vous avez bien accés à votre cluster

```bash

export KUBECONFIG=$(pwd)/kubeconfig

kubectl version --short
kubectl get no

```

## Récupération de l'IP de votre cluster

```bash

export IP=$(terraform output -json | jq -r .ip.value)
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_civo"></a> [civo](#requirement\_civo) | 1.0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_civo"></a> [civo](#provider\_civo) | 1.0.9 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [civo_firewall.my-firewall](https://registry.terraform.io/providers/civo/civo/1.0.9/docs/resources/firewall) | resource |
| [civo_firewall_rule.ingress_http](https://registry.terraform.io/providers/civo/civo/1.0.9/docs/resources/firewall_rule) | resource |
| [civo_firewall_rule.ingress_https](https://registry.terraform.io/providers/civo/civo/1.0.9/docs/resources/firewall_rule) | resource |
| [civo_firewall_rule.kubernetes](https://registry.terraform.io/providers/civo/civo/1.0.9/docs/resources/firewall_rule) | resource |
| [civo_firewall_rule.nodeports](https://registry.terraform.io/providers/civo/civo/1.0.9/docs/resources/firewall_rule) | resource |
| [civo_kubernetes_cluster.my_kube_cluster](https://registry.terraform.io/providers/civo/civo/1.0.9/docs/resources/kubernetes_cluster) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [civo_size.xsmall](https://registry.terraform.io/providers/civo/civo/1.0.9/docs/data-sources/size) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_civo_token"></a> [civo\_token](#input\_civo\_token) | Civo API Token | `string` | n/a | yes |
| <a name="input_story_name"></a> [story\_name](#input\_story\_name) | n/a | `string` | `"my_kube_cluster"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip"></a> [ip](#output\_ip) | n/a |
<!-- END_TF_DOCS -->