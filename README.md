1.
Команда для создания ключа:
```
ssh-keygen -t rsa -b 2024 -f ~/.ssh/id_rsa_vkcs
```
Настройка окружения для openstack и terraform
```
source ~/<projec_name>-openrc-v3.sh
```
Скачивание и установка binary
```
wget http://hub.mcs.mail.ru/repository/terraform-binary/mirror/1.1.9/terraform_1.1.9_linux_amd64.zip
unzip terraform_1.1.9_linux_amd64.zip
cp terraform /usr/local/bin
chmod +x /usr/local/bin/terraform
```
Настройка terraform
```
cat <<EOF > ~/.terraformrc
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.mcs.mail.ru"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}

EOF
```
Проверка и установка providers
```
terraform init
```
Установка openstack client
```
python3 -m pip install python-openstackclient
```
Проверка
```
openstack image list
```
Настройка окружения для openstack и terraform
```
source ~/<projec_name>-openrc-v3.sh
```
Развертываение
```
terrafom apply
```
2.
Запуск ansible
```
cd ansible && ansible-playbook -i ../inventory main.yml
```
3.
Проверка pipeline
```
cd backend
git checkout master
git pull
git checkout -b "my_awesome_branch"
git commit -am "my awesome change"
git push origin


```
