#!/bin/bash

source common.sh

run_command "tree terraform"

read

run_command "terraform init" "terraform"
