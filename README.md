# Goldie's Lock and Threeway secrets

> Script Complet : https://gist.github.com/Sphinxgaia/5ebade30bac57f680305ecf774a7bd11

## Démarrage de notre environnement

> Attention jouer toutes les instructions dans le même shell pour éviter la perte de variable d'environnement

exporter votre token d'infra pour déployer sur votre cloud provider

```bash

export CIVO_TOKEN=my_token

```

Suivre les instructions de chaque dossier ou la documentation suivante pas à pas


### Déploiement de l'infrastructure

```bash
export WORK_HOME=$(pwd)
cd $WORK_HOME/bootstrap/k8s-cluster/civo-cluster

cat <<EOF > creds.auto.tfvars
civo_token = "$CIVO_TOKEN"
EOF

export TF_VAR_story_name=goldieslocks
terraform init
terraform apply -auto-approve

sleep 60

export KUBECONFIG=$(pwd)/kubeconfig

kubectl version --short
kubectl get no

export IP=$(terraform output -json | jq -r .ip.value)

```

Une fois l'infrastructure déployée et l'IP récupérer, vous pouvez déployer la suite.

### Déploiement de Vault

> Attention, ici Vault n'est pas déployé en HA ni avec auto-unseal

Installation préalable

```bash

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm upgrade --install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --set syncSecret.enabled=true --namespace kube-system

# Attente de récupération des pods du Secret store CSI Driver
sleep 60

cd $WORK_HOME/bootstrap/vault
export KUBE_CONFIG_PATH=$KUBECONFIG
export KUBE_CTX=$TF_VAR_story_name
terraform init
terraform apply -auto-approve

```

Test de Vault et préparation pour les configurations suivantes

on expose le port de Vault en local (en production, vous utiliserez le ingress de votre application)

```bash

kubectl port-forward -n vault-master svc/vault-master 8200:8200 &

open http://localhost:8200

```

Extraction des informations et déverouillage de Vault

```bash

export VAULT_ADDR="http://localhost:8200"

curl -s --request POST --data '{"secret_shares": 3, "secret_threshold": 2}' $VAULT_ADDR/v1/sys/init > tf.init

export ROOT_TOKEN=$(cat tf.init | jq -r '.root_token' )

curl -s --request POST --data "{\"key\": $(cat tf.init | jq '.keys[0]' )}" $VAULT_ADDR/v1/sys/unseal | jq

curl -s --request POST --data "{\"key\":  $(cat tf.init | jq '.keys[1]' )}" h$VAULT_ADDR/v1/sys/unseal | jq

```

### Déploiement des secrets

```bash

cd $WORK_HOME/bootstrap/secrets

export VAULT_TOKEN=$ROOT_TOKEN 
export KUBE_CONFIG_PATH=$KUBECONFIG
export KUBE_CTX=$TF_VAR_story_name

export TF_VAR_vault_addr="http://localhost:8200" 
terraform init
terraform apply -auto-approve

kubectl get ns | grep bear
kubectl get sa -A | grep bear

```

### Déploiement des applications

> Attention à chaque étapes, cela remplace l'ancienne application

Lancement de l'application témoin

```bash
cd $WORK_HOME/apps/deploy
kubectl create sa goldieslocks -n default
kubectl apply -f _goldieslocks/manifest.yaml -n default

open http://$IP:30001

```

Lancement de l'application récupérant une version spécifique d'un secret et test de rotation

```bash

cd $WORK_HOME/apps/deploy/soup

kubectl apply -f api/manifest.yaml -n bigbear-api
kubectl apply -f injector/manifest.yaml -n midbear-injector
kubectl apply -f csi/secret.yaml -n littlebear-csi
kubectl apply -f csi/manifest.yaml -n littlebear-csi

open http://$IP:30010
open http://$IP:30011
open http://$IP:30012

```

Lancement de l'application récupérant un secret et le mettant en variable d'environnement

```bash

cd $WORK_HOME/apps/deploy/chair

kubectl apply -f api/manifest.yaml -n bigbear-api
kubectl apply -f injector/manifest.yaml -n midbear-injector
kubectl apply -f csi/secret.yaml -n littlebear-csi
kubectl apply -f csi/manifest.yaml -n littlebear-csi

open http://$IP:30020
open http://$IP:30021
open http://$IP:30022

```

une fois déployer, on crée un nouvelle version de secret pour notre application

> cela sous-entend que vous avez exporter au préalable deux variable `VAULT_TOKEN` & `VAULT_ADDR` et que vous avez le binaire Vault sur votre machine

```bash
# injector
echo "csi" | vault kv put littlebear/chair etat=-
echo "injcetor" | vault kv put midbear/chair etat=-
echo "api" | vault kv put bigbear/chair etat=-

# ...
kubectl patch deployment -n midbear-injector goldieslocks-body --patch-file injector/patch.yaml
```

Partie Finale, montage des secrets en variables d'environnement

> L'image de l'injector Vault n'existe pas

```bash

cd $WORK_HOME/apps/deploy/bed

kubectl apply -f api/manifest.yaml -n bigbear-api
kubectl apply -f injector/manifest.yaml -n midbear-injector
kubectl apply -f csi/secret.yaml -n littlebear-csi
kubectl apply -f csi/manifest.yaml -n littlebear-csi

open http://$IP:30030
open http://$IP:30031
open http://$IP:30032

```

### Contrôle des audits logs

> Lors du déploiement de Vault, les audits logs sont configurées pour être affichées sur la sortie standard du container

Extraction et mise en forme des audits logs

```bash

kubectl logs -n vault-master vault-master-0 \
| grep '"role":"bigbear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'soup' --before-context=2 --after-context=2


kubectl logs -n vault-master vault-master-0 \
| grep '"role":"midbear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'soup' --before-context=2 --after-context=2


kubectl logs -n vault-master vault-master-0 \
| grep '"role":"littlebear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'soup' --before-context=2 --after-context=2

```

idem pour les autres secrets


```bash

kubectl logs -n vault-master vault-master-0 \
| grep '"role":"bigbear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'chaise' --before-context=2 --after-context=2


kubectl logs -n vault-master vault-master-0 \
| grep '"role":"midbear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'chaise' --before-context=2 --after-context=2


kubectl logs -n vault-master vault-master-0 \
| grep '"role":"littlebear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'chaise' --before-context=2 --after-context=2

```

pour les lits

```bash

kubectl logs -n vault-master vault-master-0 \
| grep '"role":"bigbear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'bed' --before-context=2 --after-context=2


kubectl logs -n vault-master vault-master-0 \
| grep '"role":"midbear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'bed' --before-context=2 --after-context=2


kubectl logs -n vault-master vault-master-0 \
| grep '"role":"littlebear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'bed' --before-context=2 --after-context=2

```

extra affichage des tentatives de connexion


```bash

kubectl logs -n vault-master vault-master-0 \
| grep '"role":"bigbear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'login' --before-context=2 --after-context=2


kubectl logs -n vault-master vault-master-0 \
| grep '"role":"midbear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'login' --before-context=2 --after-context=2


kubectl logs -n vault-master vault-master-0 \
| grep '"role":"littlebear"' \
| jq -r '. | { who: .auth.metadata.service_account_name, what: .request.path, when: .time}' \
| grep 'login' --before-context=2 --after-context=2

```

## Nettoyage de notre environnement

```bash
cd $WORK_HOME/bootstrap/k8s-cluster/civo-cluster

terraform destroy -auto-approve
```