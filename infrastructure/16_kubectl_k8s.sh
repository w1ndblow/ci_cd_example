#!/bin/bash

source common.sh

export KUBECONFIG=infrastructure/k8s-cluster_kubeconfig.yaml




run_command "echo \$(kubectl get secret github-secret -o jsonpath='{.data.token}') | base64 -d" ".."

read
