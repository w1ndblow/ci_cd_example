run_command () {

WORK_DIR=$(pwd)
clear
if [ ! -z "$2" ]; then
    cd $2;
fi
echo "директория запуска"
echo ""
echo "     [1;32m$(pwd)[0m"
echo ""
echo "запуск команды"
echo ""
echo "     [1;36m${1/github_authtoken=*/github_authtoken=<ваш токен>}"
echo "[0m"

read
echo "вывод команды"
echo ""
eval $1

cd $WORK_DIR
}
