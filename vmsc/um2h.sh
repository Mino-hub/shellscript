#!/bin/bash
#
#| |  / (_)____/ /___  ______ _/ / __ )____  _  __   / / / /___  /  |/  /___  __  ______  / /____  _____
#| | / / / ___/ __/ / / / __ `/ / __  / __ \| |/_/  / / / / __ \/ /|_/ / __ \/ / / / __ \/ __/ _ \/ ___/
#| |/ / / /  / /_/ /_/ / /_/ / / /_/ / /_/ />  <   / /_/ / / / / /  / / /_/ / /_/ / / / / /_/  __/ /    
#|___/_/_/   \__/\__,_/\__,_/_/_____/\____/_/|_|   \____/_/ /_/_/  /_/\____/\__,_/_/ /_/\__/\___/_/     
#
# VMのシャットダウンスクリプト
#
# 2015.7.29
# 2015.12.28 -- sshfsの使用中止

white_green="\e[37;42;1m"
white_red="\e[37;41;1m"
colorEnd="\e[m"

#引数確認
if [ $# -eq 0 ]; then
    /bin/echo -e "${white_red}VM名を指定してください${colorEnd}"
    exit 1
fi

#起動確認
VBoxManage list runningvms | grep "$1";isRunning=$?
if [ $isRunning -ne 0 ]; then
    /bin/echo -e "${white_red}$1は起動していません${colorEnd}"
    exit 1
fi

# fusermount -u -z /home/pecodrive/Documents/project/mounter/ > /dev/null 2>&1;isunmount=$?
# if [ $isunmount -ne 0 ]; then
#     /bin/echo -e "${white_red}アンマウント失敗${colorEnd}"
# elif [ $isunmount -eq 0 ]; then
#     /bin/echo -e "${white_green}アンマウント成功${colorEnd}"
# fi

VBoxManage controlvm $1 poweroff >/dev/null 2>&1
/bin/echo -e "${white_green}VMをシャットダウンしました${colorEnd}"

exit 0
