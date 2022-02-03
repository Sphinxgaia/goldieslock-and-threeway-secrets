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
