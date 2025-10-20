#!/bin/bash

source common.sh

run_command "terraform destroy" "terraform-k8s"
