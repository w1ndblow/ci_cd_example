#!/bin/bash

source common.sh

POSTGRES_PASSWORD=Test_$(openssl rand -base64 12)

run_command "kubectl create secret generic database-auth \
    --from-literal=username=app_user \
    --from-literal=password=$POSTGRES_PASSWORD \
    --from-literal=database=appdb
    --from-literal=postgresPassword=$POSTGRES_PASSWORD"

echo "Вaш пароль $POSTGRES_PASSWORD"
