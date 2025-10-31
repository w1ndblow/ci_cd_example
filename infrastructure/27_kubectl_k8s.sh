#!/bin/bash

source common.sh

echo "Введите gitlab token с доступом к registry:"
read -s GITLAB_REGISTRY_TOKEN

run_command "kubectl create secret docker-registry gitlab \
        --docker-server=registry.gitlab.com/w1ndblow/ci-cd-example \
        --docker-username=deploy \
        --docker-password=$GITLAB_REGISTRY_TOKEN \
        --namespace=default" "k8s_gitlab"
