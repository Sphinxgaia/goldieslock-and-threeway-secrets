#!/usr/bin/env bash

declare -a TAGS=("basic" "goldieslocks" "csi" "injector" "api")

for TAG in "${TAGS[@]}"
do
  echo ""
  echo "------------------"
	echo "--> building version $TAG"
	echo "------------------"

  echo ""
	echo "--> goldie main"
  if ! docker build -f main/docker/Dockerfile ./main --build-arg VERSION="${TAG}" --tag "${REPOSITORY}"/goldie-main:"${TAG}"; then
    echo "goldie main build failed with rc $?"
    exit 1
  fi

	echo "--> goldie body"
  if ! docker build -f body/docker/Dockerfile ./body --build-arg VERSION="${TAG}" --tag "${REPOSITORY}"/goldie-body:"${TAG}"; then
    echo "goldie main build failed with rc $?"
    exit 1
  fi


  if [[ ! -z ${PUSH} ]]; then
    echo ""
    echo "--> pushing images for tag $TAG"
    (docker push "${REPOSITORY}"/goldie-main:"${TAG}" && \
    docker push "${REPOSITORY}"/goldie-body:"${TAG}") || exit 1
  fi

done
