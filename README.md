# Django delivery Repository

This repo contains several approach to delivery your django app

## Infrastructure

### terraform vkcloud

### ansible provision

Если вы запускаете только ansible, вы можете указать ip вашей виртульной машины вручную в файле инвенторизации, если запуск проходит после terraform файл `inventory` заполнится автоматически

```bash
cd infrastructure
vi inventory
```

Запуск 
```bash
cd ansible && ansible-playbook -i ../inventory main.yml
```

### deploy

### docker-compose

### kubernetes

### kubernetes-helm

## Проверка pipeline

```
git checkout master
git pull
git checkout -b "my_awesome_branch"
git commit -am "my awesome change"
git push origin
```
