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