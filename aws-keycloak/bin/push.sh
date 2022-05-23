#!/bin/bash
CHART=keycloak
PROFILE=${PROFILE:-default}
REGION=${REGION:-eu-west-1}
ACCOUNT=${ACCOUNT:-523334766143}
ECR_HOST="${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com"
REGISTRY="${ECR_HOST}/chart/${CHART}"
VERSION=`helm show chart .. | grep '^version:' | sed 's/\s\+//g'  | cut -d ':' -f 2  | xargs`

export HELM_EXPERIMENTAL_OCI=1

aws ecr get-login-password --profile ${PROFILE} | helm registry login --username AWS --password-stdin $ECR_HOST

echo "Publicando versión ${REGISTRY}:${VERSION}"

cd .. && \
helm dep update . && \
helm chart save . ${CHART} && \
helm chart save . "${REGISTRY}:${VERSION}" && \
helm chart push "${REGISTRY}:${VERSION}"
