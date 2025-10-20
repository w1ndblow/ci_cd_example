#!/bin/bash

source common.sh

run_command "kubectl create token ci-deploy" "k8s_gitlab"
