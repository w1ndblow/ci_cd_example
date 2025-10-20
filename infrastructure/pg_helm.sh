
#!/bin/bash

# быстрое и бюджетное создание базы данных
# внимание без персистентности


helm upgrade --install testpostgresql bitnami/postgresql \
 --set global.postgresql.auth.username=app_user  \
 --set global.postgresql.auth.password=app_password	\
 --set global.postgresql.auth.database=appdb  \
 --set primary.persistence.enabled=false
