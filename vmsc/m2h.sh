#!/bin/bash
#  _    ___      __              ______                __  ___                  __           
# | |  / (_)____/ /___  ______ _/ / __ )____  _  __   /  |/  /___  __  ______  / /____  _____
# | | / / / ___/ __/ / / / __ `/ / __  / __ \| |/_/  / /|_/ / __ \/ / / / __ \/ __/ _ \/ ___/
# | |/ / / /  / /_/ /_/ / /_/ / / /_/ / /_/ />  <   / /  / / /_/ / /_/ / / / / /_/  __/ /    
# |___/_/_/   \__/\__,_/\__,_/_/_____/\____/_/|_|  /_/  /_/\____/\__,_/_/ /_/\__/\___/_/     
#
# VirtualBox自動起動及び自動ssh接続スクリプト
# 2015.7.29 
# 2015.12.28 -- sshfsの使用を取りやめてsshでの接続とした 

# . ~/pecosh/vmsc/vmsrc.sh

white_green="\e[37;42;1m"
white_red="\e[37;41;1m"
colorEnd="\e[m"

#引数確認
if [ $# -eq 0 ]; then
    /bin/echo -e "${white_red}VM名を指定してください${colorEnd}"
    exit 1
fi

vmname=$1

VBoxManage list vms | grep "$1";isvms=$?
if [ $isvms -ne 0 ]; then
    /bin/echo -e "${white_red}指定されたVM名は存在しません${colorEnd}"
    /bin/echo -e "${white_red}存在するVM名は以下です${colorEnd}"
    VBoxManage list vms
    exit 1
fi

#起動確認
VBoxManage list runningvms | grep "$1";isRunning=$?
if [ $isRunning -eq 0 ]; then
    /bin/echo -e "${white_red}$1はすでに起動しています${colorEnd}"
    exit 1
fi

#VM起動
VBoxManage startvm "$1" --type headless > /dev/null 2>&1
/bin/echo -e "${white_green}VM起動${colorEnd}"
#OSが起動するまでに約１分かかるのでウエイトを挟む
e=0
/bin/echo -e "${white_green}OS起動待機中(60秒待ちます)${colorEnd}"
for e in 0 5 10 15 20 25 30 35 40 45 50 55 60; do
    echo -n "$e秒…\r" 
    sleep 5s
done

#ssh接続
vmname="ssh -M -p22 -i ~/.ssh/centos66rsa vagrant@centos66"
# vmname="ssh -p22 vagrant@centos66"
count=0
/bin/echo -e "${white_green}ssh接続中…${colorEnd}"
until eval ${vmname}
do
    echo -n "$?…"
    sleep 5s	
    count=$((count+1))
    if [ $count -gt 20 ]; then
	/bin/echo -e "${white_red}20回試行したがダメでした${colorEnd}"
	exit 255
    fi    
done 

exit 0
