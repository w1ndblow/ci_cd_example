#!/bin/bash

source common.sh

run_command "tree ansible"

echo "Введите github token:"
read -s github_token

github_owner=$(git remote -v | head -n 1 | cut -d ":" -f2 | cut -d "/" -f1)
github_repo=$(git remote -v | head -n 1 | cut -d ":" -f2 | cut -d "/" -f2| cut -d "." -f1)

run_command "ansible-playbook main.yml -i ../inventory -e github_owner=$github_owner -e github_repo=$github_repo -e github_authtoken=$github_token -v" "ansible"
