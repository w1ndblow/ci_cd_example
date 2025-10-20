#!/bin/bash

source common.sh

run_command "kubectl create serviceaccount ci-deploy" "k8s_gitlab"
