#!/bin/bash

source common.sh

run_command "tree k8s_gitlab"

echo "Введите gitlab token:"
read -s gitlab_token

run_command "kubectl create secret -n default generic 'gitlab-runner-secret' --from-literal runner-token=$gitlab_token --from-literal runner-registration-token=''" "ansible-k8s"
