#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

checkupdate(){
    echo "正在进行检查更新!"
	rm -rf /usr/local/bin/newversion
	wget -N --no-check-certificate -O /usr/local/bin/newversion https://raw.githubusercontent.com/${GH_REPO}/master/version
	chmod +x /usr/local/bin/newversion
	var=`head -1 version` #非单引号，是ESC 下面的键
	echo "您当前的版本号为：$var "
	var=${var//./ }    #这里是将var中的,替换为空格 
	declare -a version1=($var)
	var=`head -1 newversion` #非单引号，是ESC 下面的键
	echo "最新的版本号为：$var "
	var=${var//./ }    #这里是将var中的,替换为空格 
	declare -a version2=($var)
	if [[ ${version1[0]} < ${version2[0]} && ]]  #主版本号小
	then
		echo '即将更新'
	elif [[ ${version1[0]} = ${version2[0]} && ${version1[1]} < ${version2[1]} ]] #次版本号小
	then
		echo '即将更新'
	elif [[ ${version1[0]} = ${version2[0]} && ${version1[1]} = ${version2[1]} && ${version1[2]} < ${version2[2]} ]] #修订版本号小
	then
		echo '即将更新'
	fi
}

echo "测试区域，请勿随意使用"
echo "1.更新SSR-Bsah"
echo "2.一键封禁BT下载，SPAM邮件流量（无法撤销）"
echo "3.防止暴力破解SS连接信息 (重启后失效)"

while :; do echo
	read -p "请选择： " devc
	[ -z "$devc" ] && ssr && break
	if [[ ! $devc =~ ^[1-3]$ ]]; then
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
done

case $devc in

1)
	checkupdate
	#rm -rf /usr/local/bin/ssr
	#cd /usr/local/SSR-Bash-Python/
	#git pull
	#wget -N --no-check-certificate -O /usr/local/bin/ssr https://raw.githubusercontent.com/${GH_REPO}/master/ssr
	#chmod +x /usr/local/bin/ssr
	#echo 'SSR-Bash升级成功！'
	#ssr
;;
	
2)
	wget -4qO- softs.pw/Bash/Get_Out_Spam.sh|bash
;;

3)
	nohup tail -F /usr/local/shadowsocksr/ssserver.log | python autoban.py >log 2>log &
;;
esac
