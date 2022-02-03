# Goldie Apps

## Les dossiers

Le dossier `src` contient les sources de notre application.

Elle est basée sur l'application podtato-head en version simplifié pour n'afficher qu'une seule image.

Le dossier `deploy' contient les éléments de déploiement dans Kubernetes

## Build de vos applications

> se connecter à votre dépôt d'image OCI

```bash
export REPOSITORY=ghcr.io/sphinxgaia
export PUSH=true

cd src
./build.main.sh
```


## Déploiement des applications

> Attention à chaque étapes, cela remplace l'ancienne application

Lancement de l'application témoin

```bash
export $WORK_HOME=$(pwd)
export $IP=<IP de votre cluster>

cd $WORK_HOME/deploy
kubectl create sa goldieslocks -n default
kubectl apply -f _goldieslocks/manifest.yaml -n default

open http://$IP:30001

```

Lancement de l'application récupérant une version spécifique d'un secret et test de rotation

```bash

cd $WORK_HOME/deploy/soup

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

cd $WORK_HOME/deploy/chair

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

cd $WORK_HOME/deploy/bed

kubectl apply -f api/manifest.yaml -n bigbear-api
kubectl apply -f injector/manifest.yaml -n midbear-injector
kubectl apply -f csi/secret.yaml -n littlebear-csi
kubectl apply -f csi/manifest.yaml -n littlebear-csi

open http://$IP:30030
open http://$IP:30031
open http://$IP:30032

```
