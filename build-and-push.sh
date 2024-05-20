#!/bin/bash
set -eu

cd $(dirname $0)

. settings

TERRAFORM_VERSION="${1}"
BASE_IMAGE_AWS_CLI="${2}"

AWS_CLI_MAJOR=$(echo "${BASE_IMAGE_AWS_CLI}" | cut -d '.' -f 1)

if [ $AWS_CLI_MAJOR -gt 1 ]; then
  TAG="v2"
else
  TAG="v1"
fi;

docker build \
  --build-arg BASE_IMAGE_AWS_CLI="${BASE_IMAGE_DOCKERHUB_REPO}:${BASE_IMAGE_AWS_CLI}" \
  --build-arg TERRAFORM_VERSION="${TERRAFORM_VERSION}" \
  -t "${DOCKERHUB_REPO}:${TERRAFORM_VERSION}-aws-cli-${TAG}" \
  .

docker push "${DOCKERHUB_REPO}:${TERRAFORM_VERSION}-aws-cli-${TAG}"