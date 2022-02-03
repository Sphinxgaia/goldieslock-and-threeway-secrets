# Installation VAULT

Configuration de votre environnement Vault

## Prérequis

> Pour fonctionner le CSI Driver de Vault doit pouvoir s'appuyer sur le secret store csi driver de Kubernetes

```bash

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm upgrade --install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --set syncSecret.enabled=true --namespace kube-system

```

## Lancement de votre application

```bash

export KUBE_CONFIG_PATH=$KUBECONFIG
export KUBE_CTX=$TF_VAR_story_name

terraform init
terraform apply -auto-approve # don't do that in production
```

## Initialisation

Démarrer une connexion via un tunnel sur votre poste

```bash
kubectl port-forward -n vault-master svc/vault-master 8200:8200
```

Ouvrez un navigateur si vous le souhaitez : [Vault UI](http://localhost:8200) ou avec la commande

```bash
open http://localhost:8200
```

### API

Initialisation de votre Vault. Nous partons du principe que vous avez jq d'installer sur votre machine.

```bash
export VAULT_ADDR="http://localhost:8200"

curl -s --request POST --data '{"secret_shares": 3, "secret_threshold": 2}' $VAULT_ADDR/v1/sys/init > tf.init

```

>File sample :

```console
{
  "keys": [
    "7e2820bfd0fd6e633407b47d49fc4a2e465e56348eb603e6493f42a925508301ff",
    "001ece3772eb8ba7a3ce37d703fc5c96bdfdf9fbcb700e9c0021f38d697167e2e9",
    "a856bdcc182a154585c9215412fc9d2d0b6276f4ce63ebcd150954fd700d0c7428"
  ],
  "keys_base64": [
    "figgv9D9bmM0B7R9SfxKLkZeVjSOtgPmST9CqSVQgwH/",
    "AB7ON3Lri6ejzjfXA/xclr39+fvLcA6cACHzjWlxZ+Lp",
    "qFa9zBgqFUWFySFUEvydLQtidvTOY+vNFQlU/XANDHQo"
  ],
  "root_token": "s.I5PYQZo5GSblQNv4JXjuAp5X"
}
```

> Si vous n'avez pas utiliser l'auto-unseal, vous devez déverrouiller votre Vault

```bash
export ROOT_TOKEN=$(cat tf.init | jq -r '.root_token' )

curl -s --request POST --data "{\"key\": $(cat tf.init | jq '.keys[0]' )}" $VAULT_ADDR/v1/sys/unseal | jq

curl -s --request POST --data "{\"key\":  $(cat tf.init | jq '.keys[1]' )}" h$VAULT_ADDR/v1/sys/unseal | jq

```

## Retournons à la racine

[Racine](../../)