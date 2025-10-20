#!/bin/bash

source common.sh

run_command "helm install --namespace default gitlab-runner -f values.yaml gitlab/gitlab-runner" "k8s_gitlab"
