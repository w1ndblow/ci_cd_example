#!/bin/bash

source common.sh

echo "Введите github token:"
read -s POSTGRES_PASSWORD



run_command "helm upgrade --install --atomic testpostgresql oci://registry-1.docker.io/bitnamicharts/postgresql \
         --set global.postgresql.auth.username=app_user  \
         --set global.postgresql.auth.password="$POSTGRES_PASSWORD"\
         --set global.postgresql.auth.database=appdb  \
         --set primary.persistence.enabled=false" "k8s_gitlab"
