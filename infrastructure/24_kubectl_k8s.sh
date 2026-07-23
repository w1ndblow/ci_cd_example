#!/bin/bash

source common.sh

run_command "kubectl create serviceaccount ci-deploy && kubectl create rolebinding sa-namespace-ci-deploy-binding   --clusterrole=admin   --serviceaccount=default:ci-deploy   --namespace=default" "k8s_gitlab"
