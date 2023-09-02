#!/bin/bash
set -eux

cd $(dirname $0)

REFS_TAG=$(git ls-remote --tags https://github.com/hashicorp/terraform | awk '{print $2}' | grep /v1. | grep -v '{}' | grep -v 'rc' | grep -v 'alpha' | grep -v 'beta' | sort -rV | head -n1)
CURRENT_TERRAFORM_VERSION=${REFS_TAG/"refs/tags/v"/""}

REFS_TAG=$(git ls-remote --tags https://github.com/mmpiotrowski/aws-cli.git| awk '{print $2}' | grep /1. | sort -rV | head -n1)
BASE_IMAGE_AWS_CLI_V1=${REFS_TAG/"refs/tags/"/""}

REFS_TAG=$(git ls-remote --tags https://github.com/mmpiotrowski/aws-cli.git | awk '{print $2}' | grep /2. | sort -rV | head -n1)
BASE_IMAGE_AWS_CLI_V2=${REFS_TAG/"refs/tags/"/""}

UPDATED=0

if ! git tag -l | grep -q "${CURRENT_TERRAFORM_VERSION}-${BASE_IMAGE_AWS_CLI_V1}"; then
   ./build-and-push.sh $CURRENT_TERRAFORM_VERSION "$BASE_IMAGE_AWS_CLI_V1"
   git tag "${CURRENT_TERRAFORM_VERSION}-${BASE_IMAGE_AWS_CLI_V1}"
   UPDATED=1
fi

if ! git tag -l | grep -q "${CURRENT_TERRAFORM_VERSION}-${BASE_IMAGE_AWS_CLI_V2}"; then
   ./build-and-push.sh $CURRENT_TERRAFORM_VERSION "$BASE_IMAGE_AWS_CLI_V2"
   git tag "${CURRENT_TERRAFORM_VERSION}-${BASE_IMAGE_AWS_CLI_V2}"
   UPDATED=1
fi

#https://joht.github.io/johtizen/build/2022/01/20/github-actions-push-into-repository.html#example-1
if [ ${UPDATED} != 0 ]; then
    git commit --allow-empty -m "Update terraform versions"
    git push && git push --tags
fi



